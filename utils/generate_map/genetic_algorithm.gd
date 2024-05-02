class_name GeneticAlgorithm

const roomSize : int = 1
const numberPopulation : int = 10
const selectedProportion : float = 0.4
const selectedNumber : int = numberPopulation * selectedProportion
const maxGeneration : int = 10

const mutateChance : float = 0.01

var sketchMap : Array[Map]
var selectedPop : Array[Map]

var generation : int 

var constrain1 : SaveLog = SaveLog.new("PlayableScore")
var constrain2 : SaveLog = SaveLog.new("ExitTileScore")
var constrain3 : SaveLog = SaveLog.new("OverAllScore")
var constrain4 : SaveLog = SaveLog.new("ExitExploreScore")

const log1 : bool = false

func getMap() -> Map:
	generateMap()
	var bestMap : int = findBestMap()
	while (bestMap == -1):
		generateMap()
		bestMap = findBestMap()
	sketchMap[bestMap].display()
	print("score " + str(sketchMap[bestMap].specialTilesScore))
	return sketchMap[bestMap]
	
func findBestMap() -> int:
	var indexBestMap : int = -1
	var threshold : float = 0
	for i in range(sketchMap.size()):
		if(sketchMap[i].specialTilesScore > threshold && 
		sketchMap[i].isPlayable == true):
			indexBestMap = i
			threshold = sketchMap[i].specialTilesScore
	return indexBestMap

func  generateMap():
	generation = 1
	print("generation " + str(generation))
	firstGeneration()
	evaluate()
	for i in range(sketchMap.size()):
		if(log1):
			print(str(i+1) + " " + str(sketchMap[i].isPlayable))
	for i in range(maxGeneration):
		tournamentSelection()
		generateNewPopulation()
		generation += 1
		print("generation " + str(generation))
		evaluate()
	for i in range(sketchMap.size()):
		print(sketchMap[i].isPlayable)
		print(sketchMap[i].specialTilesScore)
		print("exit explore " + str(sketchMap[i].exitExplorScore))
		sketchMap[i].display()
	constrain1.save()
	constrain2.save()
	constrain3.save()
	constrain4.save()
	
#spawn
func firstGeneration():
	sketchMap.clear()
	sketchMap.resize(numberPopulation)
	for i in range(sketchMap.size()):
		sketchMap[i] = Map.new()
		sketchMap[i].random()
		if(log1):
			print("Map " + str(i + 1))
			sketchMap[i].display()

#evaluate		
func evaluate():
	var sumPlayable : float = 0.0
	var sumExitTile : float = 0.0
	var sumOverAll : float = 0.0
	var minExit : float = Map.mapSize * 10
	var maxExit : float = 0.0
	var sumExitExplore : float = 0.0
	#evaluate and find minmax
	for i in range(sketchMap.size()):
		sketchMap[i].evaluate()
		if(sketchMap[i].exitTileScore > maxExit):
			maxExit = sketchMap[i].exitTileScore
		if(sketchMap[i].exitTileScore < minExit):
			minExit = sketchMap[i].exitTileScore
	#print("min = " + str(minExit) + " max = " + str(maxExit))
	#cal score
	for i in range(sketchMap.size()):
		#print("map " + str(i) + " score before " + str(sketchMap[i].exitTileScore))
		sketchMap[i].exitTileScore = (1.0 - normalize(minExit, maxExit, sketchMap[i].exitTileScore)) 
		#print(sketchMap[i].exitTileScore)
		#print("playable " + str(sketchMap[i].playableScore))
		#print("exit " + str(sketchMap[i].exitTileScore))
		sumPlayable += sketchMap[i].playableScore
		sumExitTile += sketchMap[i].exitTileScore
		sumExitExplore += sketchMap[i].exitExplorScore
		#print("explore " + str(sketchMap[i].exitExplorScore))
		sketchMap[i].specialTilesScore = (sketchMap[i].exitTileScore * 0.4) + (sketchMap[i].playableScore * 0.2)
		+ (sketchMap[i].exitExplorScore * 0.4)
		#print("overall " + str(sketchMap[i].specialTilesScore))
		sumOverAll += sketchMap[i].specialTilesScore
	sumPlayable = sumPlayable / sketchMap.size()
	sumExitTile = sumExitTile / sketchMap.size()
	#print("sum before" + str(sumExitExplore))
	sumExitExplore = sumExitExplore / sketchMap.size()
	#print("sum " + str(sumExitExplore))
	sumOverAll = sumOverAll / sketchMap.size()
	constrain1.add(generation, sumPlayable)
	constrain2.add(generation, sumExitTile)
	constrain3.add(generation, sumOverAll)
	constrain4.add(generation, sumExitExplore)
#Calculation For Rullete Select
func biasedRoulette():	
	#evaluation!!!!!!!!!!!!!
	var scoreList : Array[float] = []
	var min : float = 100
	var max : float = 0
	var sum : float = 0
	for i in range(sketchMap.size()):
		scoreList.append(sketchMap[i].specialTilesScore)
		sum = sum + scoreList[i]
		if(sketchMap[i].specialTilesScore < min):
			min = sketchMap[i].specialTilesScore
		if(sketchMap[i].specialTilesScore > max):
			max = sketchMap[i].specialTilesScore
	if(log1):
		print("Min = " + str(min))
		print("Max = " + str(max))
		print(scoreList)
	var proportionList : Array[float] = []
	var biasedRoulette : Array[float]
	var totalProportion : float = 0
	for i in range(scoreList.size()):
		var num : float = scoreList[i] / sum
		proportionList.append(num)
		totalProportion = totalProportion + num
		biasedRoulette.append(totalProportion)
	if(log1):
		print(proportionList)
		print(biasedRoulette)
	selectedPop.clear()
	if(log1):
		print("selected pop number = " + str(selectedNumber))
	selectedPop.resize(selectedNumber)
	for i in range(selectedPop.size()):
		var ranPop : float = randf()
		if(log1):
			print("random = " + str(ranPop))
		for j in range(biasedRoulette.size()):
			if(ranPop <= biasedRoulette[j]):
				if(log1):
					print("Select " + str(j) + "!")
				selectedPop[i] = sketchMap[i]
				if(log1):
					selectedPop[i].display()
				break
				
func tournamentSelection():
	selectedPop.clear()
	selectedPop.resize(selectedNumber)
	var isSeleted : Array[bool]
	isSeleted.resize(numberPopulation)
	for i in range(selectedNumber):
		var candidate1 : int = randi_range(0, numberPopulation - 1)
		while(isSeleted[candidate1] == true):
			candidate1 = randi_range(0, numberPopulation - 1)
		var candidate2 : int = randi_range(0, numberPopulation - 1)
		while(candidate1 == candidate2 || isSeleted[candidate2] == true):
			candidate2 = randi_range(0, numberPopulation - 1)
		if(sketchMap[candidate1].specialTilesScore > sketchMap[candidate2].specialTilesScore):
			selectedPop[i] = sketchMap[candidate1]
			isSeleted[candidate1] = true
		else:
			selectedPop[i] = sketchMap[candidate2]
			isSeleted[candidate2] = true
				
#gen new pop			
func generateNewPopulation():
	sketchMap.clear()
	for i in range(selectedPop.size()):
		sketchMap.append(selectedPop[i])
		if(log1):
			sketchMap[i].display()
	var newPopNumber : int = numberPopulation - selectedNumber
	if(log1):
		print("new pop number = " + str(newPopNumber))
	var newPop : int = 0
	while (newPop < newPopNumber):
		var selectedParent : Array[int] = selectParent()
		var offspring : Array[Map] = uniformCrossOver(selectedPop[selectedParent[0]], selectedPop[selectedParent[1]])
		sketchMap.append(offspring[0])
		newPop += 1
		if(newPop < newPopNumber):
			sketchMap.append(offspring[1])
			newPop += 1

	#for i in range(newPopNumber):
	#	var selectedParent : Array[int] = selectParent()
	#	var offspring : Map = uniformCrossOver(selectedPop[selectedParent[0]], selectedPop[selectedParent[1]])
	#	sketchMap.append(offspring)
	for i in range(sketchMap.size()):
		if(log1):
			print("new gen " + str(i+1))
			sketchMap[i].display()
	
func selectParent() -> Array[int]:
		var parent1 : int = randi_range(0, selectedPop.size() - 1)
		if(log1):
			print("Chosen parent 1 = " + str(parent1))
		var parent2 : int = randi_range(0, selectedPop.size() - 1)
		if(log1):
			print("Chosen parent 2 = " + str(parent2))
		while(parent2==parent1):
			parent2 = randi_range(0, selectedPop.size() - 1)
			if(log1):
				print("Chosen parent 2 = " + str(parent2))
		return [parent1,parent2]
	
func singleCrossOver(parent1 : Map, parent2 : Map) -> Array[Map]:
	var offspring1 : Map = Map.new()
	var offspring2 : Map = Map.new()
	var cutindex : int = 0.5 * Map.mapSize
	if(log1):
		print("Cut index " + str(cutindex))
		print("parent 1 ")
		parent1.display()
		print("parent 2 ")
		parent2.display()
	for i in range(Map.mapSize):
		if(i < cutindex):
			offspring1.mapArray[i] = parent1.mapArray[i]
			offspring2.mapArray[i] = parent2.mapArray[i]
		else:
			offspring1.mapArray[i] = parent2.mapArray[i]
			offspring2.mapArray[i] = parent1.mapArray[i]
	if(log1):
		print("offspring")
		offspring1.display()
		offspring2.display()
	mutate(offspring1)
	mutate(offspring2)
	return [offspring1, offspring2]
	
func uniformCrossOver(parent1 : Map, parent2 : Map) -> Array[Map]:
	var offspring1 : Map = Map.new()
	var offspring2 : Map = Map.new()
	var uniform : Array[int] = []
	for i in range(Map.mapSize):
		var rand = randi_range(0,1)
		uniform.append(rand)
	for i in range(Map.mapSize):
		if(uniform[i]==0):
			offspring1.mapArray[i] = parent1.mapArray[i]
			offspring2.mapArray[i] = parent2.mapArray[i]
		else:
			offspring1.mapArray[i] = parent2.mapArray[i]
			offspring2.mapArray[i] = parent1.mapArray[i]
	mutate(offspring1)
	mutate(offspring2)
	return [offspring1, offspring2]
	
func mutate(offSpring : Map):
	var mutate : float = randf() 
	if(mutate<mutateChance):
		var randomMutate : float = randf()
		if(randomMutate > 0.5):
			mutateSwap(offSpring)
		else:
			rotateSwap(offSpring)

func mutateSwap(offSpring : Map):
	var mapLimit : int = Map.mapSize - 1
	var tile1 : int = randi_range(0, mapLimit)
	var tile2 : int = randi_range(0, mapLimit)
	while(tile1==tile2):
		tile2 = randi_range(0, mapLimit)
	var temp = offSpring.mapArray[tile1].type
	offSpring.mapArray[tile1].type = offSpring.mapArray[tile2].type
	offSpring.mapArray[tile2].type = temp
	
func rotateSwap(offSpring : Map):
	var mapLimit : int = Map.mapSize - 1
	var firstIndex : int = randi_range(0, mapLimit)
	var secondIndex : int = randi_range(0, mapLimit)
	while(firstIndex==secondIndex):
		secondIndex = randi_range(0, mapLimit)
	if(firstIndex > secondIndex):
		var temp = firstIndex
		firstIndex = secondIndex
		secondIndex = temp
	var tempArray : Array = []
	var i = firstIndex
	while(i<=secondIndex):
		tempArray.append(offSpring.mapArray[i].type)
		i += 1
	tempArray.reverse()
	for j in range(tempArray.size()):
		offSpring.mapArray[j + firstIndex].type = tempArray[j]
	
func normalize(min: float, max: float, value: float) -> float:
	if((max - min) == 0.0):
		return 0.0
	return (value - min)/(max - min)
	

