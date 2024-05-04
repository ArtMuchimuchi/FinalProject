class_name Map

const impassableTile : int = 0
const passableTile : int = 1
const exitTile : int = 2

const maxRowNumber : int = 2
const maxColumnNumber : int = maxRowNumber
const mapSize : int = maxColumnNumber * maxRowNumber

const passableList : Array[bool] = [false, true, true]
const exitList : Array[bool] = [false, false, true]
const specialTileList : Array[bool] = [false, false, true]

var mapArray : Array[Tile]
var visitedArray : Array[bool]

var specialTiles : int

var isPlayable : bool
var isSpecialConnect : bool
var playableScore : float
var exitTileScore : float
var specialTilesScore : float
var exitExplorScore : float

func  _init():
	mapArray.resize(maxColumnNumber * maxRowNumber)
	specialTiles = 0
	specialTilesScore = 0
	playableScore = 0
	exitTileScore = 0
	exitExplorScore = 0
	isPlayable = true
	isSpecialConnect = false
	for i in range(maxColumnNumber * maxRowNumber):
		mapArray[i] = Tile.new(impassableTile, i, maxRowNumber)

func getTile(column: int, row: int) -> int:
	if(column < 0 || column > maxColumnNumber || row < 0 || row > maxRowNumber):
		return -1
	return column + (maxRowNumber * row)
	
#convert real index to virtual index
func indexToVirtual(index: int) -> Array[int]:
	var arrayRealIndex : Array[int] = [-1, -1]
	#row
	arrayRealIndex[1] = index / maxRowNumber
	#column
	arrayRealIndex[0] = index - (arrayRealIndex[1] * maxRowNumber)
	return arrayRealIndex
	
func random():
	var rng = RandomNumberGenerator.new()
	for i in range(maxColumnNumber * maxRowNumber):
		var tile = rng.randi_range(0,2)
		mapArray[i] = Tile.new(tile, i, maxRowNumber)

func countSpecialTiles():
	isPlayable = true
	specialTiles = 0
	specialTilesScore = 0
	for i in range(mapSize):
		if(specialTileList[mapArray[i].type]):
			specialTiles += 1
	specialTilesScore = specialTiles 
	if(specialTiles < 1):
		isPlayable = false
			

func display():
	var line : String
	for j in range(maxRowNumber):
		line = line + "| "
		for i in range(maxColumnNumber):
			line = line + str(mapArray[getTile(i,j)].type) + " "
		line = line + "|\n"
	print(line)

#for evaluating gen map
func evaluate():
	#if no special tiles set to not playable
	countSpecialTiles()
	#cal exut tiles score and if below than 2 set playable to false
	checkExitTile()
	if(specialTiles != 0):
		checkConnection()
	if(isSpecialConnect && isPlayable):
		calExitExplore()
	else:
		exitExplorScore = 0
	if(isPlayable):
		playableScore = 0
		playableScore += 1
	
func checkExitTile():
	exitTileScore = 0.0
	var totalExitTiles : float = 0.0
	for i in range(mapSize):
		if(mapArray[i].type == exitTile):
			totalExitTiles += 1.0
	exitTileScore = abs(totalExitTiles - 2.0)
	
	if(totalExitTiles < 2):
		isPlayable = false;
	
func calExitExplore():
	var exitLocation : Array[int] = []
	for i in range(mapSize):
		if(exitList[mapArray[i].type]):
			exitLocation.append(i)
	exitExplorScore = averageExploration(exitLocation)	
	
#check if all special tiles are connected
func checkConnection():
	#set visited array to false
	for i in range(mapArray.size()):
		visitedArray.append(false)
	#find special tiles
	var tilesList : Array[int] = []
	for i in range(mapArray.size()):
		if(specialTileList[mapArray[i].type]):
			tilesList.append(i)
	#traverse through every grid
	var startSearch : Array[int] = indexToVirtual(tilesList[0])
	dfs(startSearch[1], startSearch[0])
	#check if special tiles are connected
	var ifConnected : bool = true
	for i in range(tilesList.size()):
		if(visitedArray[tilesList[i]]==false):
			ifConnected = false
	
	if(ifConnected == false):
		isPlayable = false
	else:
		isSpecialConnect = true

func dfs(row:int, column:int):
	if(passableList[mapArray[getTile(column, row)].type]):
		visitedArray[getTile(column, row)] = true
		if(mapArray[getTile(column, row)].top != null && visitedArray[mapArray[getTile(column, row)].top] != true):
			dfs(row - 1, column)
		if(mapArray[getTile(column, row)].right != null && visitedArray[mapArray[getTile(column, row)].right] != true):
			dfs(row, column + 1)
		if(mapArray[getTile(column, row)].bottom != null && visitedArray[mapArray[getTile(column, row)].bottom] != true):
			dfs(row + 1, column)
		if(mapArray[getTile(column, row)].left != null && visitedArray[mapArray[getTile(column, row)].left] != true):
			dfs(row, column - 1)
			
func calDistance(startingTile: int, destinationTile: int) -> float:
	var tile1: Array[int] = indexToVirtual(startingTile)
	var tile2: Array[int] = indexToVirtual(destinationTile)
	return sqrt(pow((tile1[0] - tile2[0]),2) + pow((tile1[1] - tile2[1]),2))
	
func averageExploration(tilesSet: Array[int]) -> float:
	var avgExplor : float = 0
	for i in range(tilesSet.size()):
		#print("value of " + str(tilesSet[i]))
		var explorValue : float = calExploration(tilesSet, tilesSet[i])
		#print("exp " + str(explorValue))
		avgExplor += explorValue
	return avgExplor / tilesSet.size()
	
func calExploration(tilesSet: Array[int], targetTile: int) -> float:
	#number of element in Sn
	var N : int = tilesSet.size()
	#passable tiles
	var P : float = 0
	for i in range(mapSize):
		if(passableList[mapArray[i].type]):
			P += 1
	#print("N = " + str(N))
	#print("P = " + str(P))
	var sumCoverage : float = 0
	for i in range(tilesSet.size()):
		if(tilesSet[i]!=targetTile):
			var coverage : float = floodFill(targetTile,tilesSet[i]) / P
			#print("coverage " + str(i) + " " + str(coverage))
			sumCoverage += coverage
	#print("sum before " + str(sumCoverage))
	sumCoverage = sumCoverage / (N - 1)
	#print("sum after " + str(sumCoverage))
	return sumCoverage
	
func calSepExploration(tilesSet: Array[int], targetTile: int) -> float:
	#number of element in Sn
	var N : int = tilesSet.size()
	#passable tiles
	var P : float = 0
	for i in range(mapSize):
		if(passableList[mapArray[i].type]):
			P += 1
	#print("N = " + str(N))
	#print("P = " + str(P))
	var sumCoverage : float = 0
	for i in range(tilesSet.size()):
		if(tilesSet[i]!=targetTile):
			var coverage : float = floodFill(targetTile,tilesSet[i]) / P
			#print("coverage " + str(i) + " " + str(coverage))
			sumCoverage += coverage
	#print("sum before " + str(sumCoverage))
	sumCoverage = sumCoverage / (N)
	#print("sum after " + str(sumCoverage))
	return sumCoverage
	
func floodFill(startingTile: int, destinationTile: int) -> int:
	var filled : Array[bool]
	filled.resize(mapSize)
	var inList : Array[bool]
	inList.resize(mapSize)
	var queue : Array[int] = []
	queue.append(startingTile)
	#print(queue)
	inList[startingTile] = true
	var i : int = 0
	var searchingIndex : int = startingTile
	var isReachDestination : bool = false
	while(searchingIndex != destinationTile && i < queue.size()):
		searchingIndex = queue[i]
		#print("i " + str(i))
		#print("sindex " + str(searchingIndex) + " --- " + str(destinationTile))
		#print("Search " + str(i) + " " + str(queue[i]))
		if(searchingIndex == destinationTile):
			isReachDestination = true
			#print("Reached!" + str(startingTile) + " " + str(destinationTile))
		filled[searchingIndex] = true
		#dis(filled)
		if(mapArray[searchingIndex].top != null && !filled[mapArray[searchingIndex].top] && passableList[mapArray[mapArray[searchingIndex].top].type]):
			if(!inList[mapArray[searchingIndex].top]):
				queue.append(mapArray[searchingIndex].top)
				inList[mapArray[searchingIndex].top] = true
				#print("Append " + str(mapArray[searchingIndex].top))
		if(mapArray[searchingIndex].right != null && !filled[mapArray[searchingIndex].right] && passableList[mapArray[mapArray[searchingIndex].right].type]):
			if(!inList[mapArray[searchingIndex].right]):	
				queue.append(mapArray[searchingIndex].right)
				inList[mapArray[searchingIndex].right] = true
				#print("Append " + str(mapArray[searchingIndex].right))
		if(mapArray[searchingIndex].bottom != null && !filled[mapArray[searchingIndex].bottom] && passableList[mapArray[mapArray[searchingIndex].bottom].type]):
			if(!inList[mapArray[searchingIndex].bottom]):
				queue.append(mapArray[searchingIndex].bottom)
				inList[mapArray[searchingIndex].bottom] = true
				#print("Append " + str(mapArray[searchingIndex].bottom))
		if(mapArray[searchingIndex].left != null && !filled[mapArray[searchingIndex].left] && passableList[mapArray[mapArray[searchingIndex].left].type]):
			if(!inList[mapArray[searchingIndex].left]):	
				queue.append(mapArray[searchingIndex].left)
				inList[mapArray[searchingIndex].left] = true
				#print("Append " + str(mapArray[searchingIndex].left))
		#print(queue)
		i += 1
	#print("s " + str(searchingIndex))
	#print("d " + str(destinationTile))
	#print("i " + str(i))
	#print("qu " + str(queue.size()))
	var coverage : int = 0
	for k in range(filled.size()):
		if(filled[k]):
			coverage += 1
	if(!isReachDestination):
		coverage *= -1
	#dis(filled)
	return coverage

func dis(array: Array[bool]):
	var line : String
	for j in range(maxRowNumber):
		line = line + "| "
		for i in range(maxColumnNumber):
			line = line + str(array[getTile(i,j)]) + " "
		line = line + "|\n"
	print(line)
