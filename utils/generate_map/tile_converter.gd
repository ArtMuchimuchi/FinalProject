extends Node

class_name TileConverter

func tileToGridMap(inputTile: Tile, desiredSize: int)->Array[int]:
	var resultMap : Array[int] 
	resultMap.resize(desiredSize * desiredSize)
	if(inputTile.type == Map.passableTile):
		blankRoom(inputTile, resultMap)
	elif(inputTile.type == Map.impassableTile):
		wallRoom(inputTile, resultMap)
	elif(inputTile.type == Map.exitTile):
		exitRoom(inputTile, resultMap)
	makeEdge(inputTile, resultMap)
	return resultMap

func blankRoom(inputTile: Tile,resultMap: Array[int]):
	for i in range(resultMap.size()):
		resultMap[i] = Map.passableTile
		
func wallRoom(inputTile: Tile, resultMap: Array[int]):
	for i in range(resultMap.size()):
		resultMap[i] = Map.impassableTile
		
func exitRoom(inputTile: Tile, resultMap: Array[int]):
	for i in range(resultMap.size()):
		if(i == ceil(resultMap.size() / 2)):
			print("ceil = " + str(ceil(resultMap.size() / 2)))
			resultMap[i] = Map.exitTile
		else:
			resultMap[i] = Map.passableTile
		
func makeEdge(inputTile: Tile,resultMap: Array[int]):
	if(inputTile.top == null):
		verticalSet(0, Map.impassableTile, resultMap)
	if(inputTile.bottom == null):
		verticalSet(sqrt(resultMap.size()) - 1, Map.impassableTile, resultMap)
	if(inputTile.left == null):
		horizontalSet(0, Map.impassableTile, resultMap)
	if(inputTile.right == null):
		horizontalSet(sqrt(resultMap.size()) - 1, Map.impassableTile, resultMap)
	
func verticalSet(index: int, desiredType: int, resultMap: Array[int]):
	for j in range(sqrt(resultMap.size())):
		for i in range(sqrt(resultMap.size())):
			if(j == index):
				var finalIndex = getTile(i, j, sqrt(resultMap.size()))
				resultMap[finalIndex] = desiredType
				
func horizontalSet(index: int, desiredType: int, resultMap: Array[int]):
	for i in range(sqrt(resultMap.size())):
		for j in range(sqrt(resultMap.size())):
			if(i == index):
				var finalIndex = getTile(i, j, sqrt(resultMap.size()))
				resultMap[finalIndex] = desiredType
		
func getTile(column: int, row: int, maxLenght: int) -> int:
	return column + (maxLenght * row)
