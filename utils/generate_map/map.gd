class_name Map

const impassableTile : int = 0
const passableTile : int = 1
const specialTile : int = 2

const maxRowNumber : int = 2
const maxColumnNumber : int = maxRowNumber
const mapSize : int = maxColumnNumber * maxRowNumber

var mapArray : Array[Tile]
var visitedArray : Array[bool]

var specialTiles : int

var isPlayable : bool
var specialTilesScore : int

func  _init():
	mapArray.resize(maxColumnNumber * maxRowNumber)
	specialTiles = 0
	specialTilesScore = 0
	isPlayable = true
	for i in range(maxColumnNumber * maxRowNumber):
		mapArray[i] = Tile.new(impassableTile, i, maxRowNumber)

func getTile(column: int, row: int) -> int:
	if(column < 0 || column > maxColumnNumber || row < 0 || row > maxRowNumber):
		return -1
	return column + (maxRowNumber * row)
	
#convert real index to virtual index
func indexToVirtual(index: int) -> Array[int]:
	var arrayRealIndex : Array[int] = [-1, -1]
	arrayRealIndex[1] = index / maxRowNumber
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
		if(mapArray[i].type == specialTile):
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
	countSpecialTiles()
	if(isPlayable == false):
		return
	checkConnection()
	
#check if all special tiles are connected
func checkConnection():
	#set visited array to false
	for i in range(mapArray.size()):
		visitedArray.append(false)
	#find special tiles
	var specialTypeList : Array[bool] = [false, false, true]
	var specialTilesList : Array[int] = []
	for i in range(mapArray.size()):
		if(specialTypeList[mapArray[i].type]):
			specialTilesList.append(i)
	#traverse through every grid
	var startSearch : Array[int] = indexToVirtual(specialTilesList[0])
	dfs(startSearch[1], startSearch[0])
	#check if special tiles are connected
	var ifConnected : bool = true
	for i in range(specialTilesList.size()):
		if(visitedArray[specialTilesList[i]]==false):
			ifConnected = false
	
	if(ifConnected == false):
		isPlayable = false

func dfs(row:int, column:int):
	var ifPassableArray : Array[bool] = [false, true, true]
	if(ifPassableArray[mapArray[getTile(column, row)].type]):
		visitedArray[getTile(column, row)] = true
		if(mapArray[getTile(column, row)].top != null && visitedArray[mapArray[getTile(column, row)].top] != true):
			dfs(row - 1, column)
		if(mapArray[getTile(column, row)].right != null && visitedArray[mapArray[getTile(column, row)].right] != true):
			dfs(row, column + 1)
		if(mapArray[getTile(column, row)].bottom != null && visitedArray[mapArray[getTile(column, row)].bottom] != true):
			dfs(row + 1, column)
		if(mapArray[getTile(column, row)].left != null && visitedArray[mapArray[getTile(column, row)].left] != true):
			dfs(row, column - 1)
