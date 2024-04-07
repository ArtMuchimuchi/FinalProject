class_name GeneticAlgorithm

const roomSize : int = 1
const numberPopulation : int = 10
const selectedProportion : float = 0.3
const selectedNumber : int = numberPopulation * selectedProportion
const maxGeneration : int = 2000

var sketchMap : Array[Map]
var biasedRoulette : Array[float]
var selectedPop : Array[Map]

var generation : int 

var data : SaveLog = SaveLog.new()

const log1 : bool = false

func  a():
	generation = 1
	print("generation " + str(generation))
	firstGeneration()
	evaluate()
	for i in range(sketchMap.size()):
		if(log1):
			print(str(i+1) + " " + str(sketchMap[i].isPlayable))
	for i in range(maxGeneration):
		calculateRoulette()
		selectPopulation()
		generateNewPopulation()
		generation += 1
		print("generation " + str(generation))
		evaluate()
	for i in range(sketchMap.size()):
		print(sketchMap[i].isPlayable)
		print(sketchMap[i].specialTilesScore)
		sketchMap[i].display()
	data.display()
	data.save()

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
	var sum = 0
	for i in range(sketchMap.size()):
		sketchMap[i].evaluate()
		sum += sketchMap[i].specialTilesScore
	sum = sum / sketchMap.size()
	data.add(generation, sum)
#Calculation For Rullete Select
func calculateRoulette():	
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
	biasedRoulette.clear()
	var totalProportion : float = 0
	for i in range(scoreList.size()):
		var num : float = scoreList[i] / sum
		proportionList.append(num)
		totalProportion = totalProportion + num
		biasedRoulette.append(totalProportion)
	if(log1):
		print(proportionList)
		print(biasedRoulette)
	
#select
func selectPopulation():
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
	for i in range(newPopNumber):
		var selectedParent : Array[int] = selectParent()
		var offspring : Map = crossOver(selectedPop[selectedParent[0]], selectedPop[selectedParent[1]])
		sketchMap.append(offspring)
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
	
func crossOver(parent1 : Map, parent2 : Map) -> Map:
	var offspring : Map = Map.new()
	var cutindex : int = 0.5 * Map.mapSize
	if(log1):
		print("Cut index " + str(cutindex))
		print("parent 1 ")
		parent1.display()
		print("parent 2 ")
		parent2.display()
	for i in range(Map.mapSize):
		if(i < cutindex):
			offspring.mapArray[i] = parent1.mapArray[i]
		else:
			offspring.mapArray[i] = parent2.mapArray[i]
	if(log1):
		print("offspring")
		offspring.display()
	return offspring
	
func saveLog():
	for i in range(10):
		data.add(generation, 1)
	data.display()
	
	
	

