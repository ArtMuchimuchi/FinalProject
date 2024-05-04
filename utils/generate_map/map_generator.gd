extends Node3D

class_name MapGenerator

var meshLib 

var ownerNode : Node3D
var finalMap : Map
var generator : GeneticAlgorithm
var filled : Array[bool]
var startTile : int
var realMap : Array[int]
var spawnPoint : int
var otherExit : Array[int]

const roomSize : int = 3

func _init(targetNode : Node3D, mesh):
	ownerNode = targetNode
	meshLib = mesh
	generator = GeneticAlgorithm.new()
	
func getMap():	
	#gen map
	finalMap = generator.getMap()
	finalMap.display()
	setStartingTile()
	checkExplorable(startTile)
	smoothenMap()
	finalMap.display()
	createRealMap()
	createGridMap()
	setSpawnAndExit()
	
func setStartingTile():
	var exitList : Array[int]
	for i in range(Map.mapSize):
		if(finalMap.mapArray[i].type == Map.exitTile):
			exitList.append(i)
	var ranExit : int = randi_range(0, exitList.size() - 1)
	var pickStart : int = exitList[ranExit]
	startTile = pickStart

func setSpawnAndExit():
	var exitList : Array[int]
	for i in range(realMap.size()):
		if(realMap[i] == Map.exitTile):
			exitList.append(i)
	print(exitList)
	var ranExit : int = randi_range(0, exitList.size() - 1)
	var pickStart : int = exitList[ranExit]
	spawnPoint = pickStart
	print("pick " + str(pickStart))
	for i in range(exitList.size()):
		if(i != ranExit):
			otherExit.append(exitList[i])
	print("other exit")
	print(otherExit)
	
func findExit():
	var exitList : Array[int]
	for i in range(Map.mapSize):
		if(finalMap.mapArray[i].type == Map.exitTile):
			exitList.append(i)
	print(exitList)
	var ranExit : int = randi_range(0, exitList.size() - 1)
	var pickStart : int = exitList[ranExit]
	startTile = pickStart
	print("pick " + str(pickStart))
	for i in range(exitList.size()):
		if(i != ranExit):
			otherExit.append(exitList[i])
	print("other exit")
	print(otherExit)


func checkExplorable(startingTile: int):
	filled.clear()
	filled.resize(Map.mapSize)
	var inList : Array[bool]
	inList.resize(Map.mapSize)
	var queue : Array[int] = []
	queue.append(startingTile)
	#print(queue)
	inList[startingTile] = true
	var i : int = 0
	var searchingIndex : int = startingTile
	while(i < queue.size()):
		searchingIndex = queue[i]
		#print("i " + str(i))
		#print("sindex " + str(searchingIndex) + " --- " + str(destinationTile))
		#print("Search " + str(i) + " " + str(queue[i]))
			#print("Reached!" + str(startingTile) + " " + str(destinationTile))
		filled[searchingIndex] = true
		#dis(filled)
		if(finalMap.mapArray[searchingIndex].top != null && !filled[finalMap.mapArray[searchingIndex].top] && Map.passableList[finalMap.mapArray[finalMap.mapArray[searchingIndex].top].type]):
			if(!inList[finalMap.mapArray[searchingIndex].top]):
				queue.append(finalMap.mapArray[searchingIndex].top)
				inList[finalMap.mapArray[searchingIndex].top] = true
				#print("Append " + str(mapArray[searchingIndex].top))
		if(finalMap.mapArray[searchingIndex].right != null && !filled[finalMap.mapArray[searchingIndex].right] && Map.passableList[finalMap.mapArray[finalMap.mapArray[searchingIndex].right].type]):
			if(!inList[finalMap.mapArray[searchingIndex].right]):	
				queue.append(finalMap.mapArray[searchingIndex].right)
				inList[finalMap.mapArray[searchingIndex].right] = true
				#print("Append " + str(mapArray[searchingIndex].right))
		if(finalMap.mapArray[searchingIndex].bottom != null && !filled[finalMap.mapArray[searchingIndex].bottom] && Map.passableList[finalMap.mapArray[finalMap.mapArray[searchingIndex].bottom].type]):
			if(!inList[finalMap.mapArray[searchingIndex].bottom]):
				queue.append(finalMap.mapArray[searchingIndex].bottom)
				inList[finalMap.mapArray[searchingIndex].bottom] = true
				#print("Append " + str(mapArray[searchingIndex].bottom))
		if(finalMap.mapArray[searchingIndex].left != null && !filled[finalMap.mapArray[searchingIndex].left] && Map.passableList[finalMap.mapArray[finalMap.mapArray[searchingIndex].left].type]):
			if(!inList[finalMap.mapArray[searchingIndex].left]):	
				queue.append(finalMap.mapArray[searchingIndex].left)
				inList[finalMap.mapArray[searchingIndex].left] = true
				#print("Append " + str(mapArray[searchingIndex].left))
		#print(queue)
		i += 1
	#print("s " + str(searchingIndex))
	#print("d " + str(destinationTile))
	#print("i " + str(i))
	#print("qu " + str(queue.size()))
	
func displayVisitable():
	var line : String
	for j in range(Map.maxRowNumber):
		line = line + "| "
		for i in range(Map.maxColumnNumber):
			if(filled[i + (j * Map.maxColumnNumber)]):
				line = line + str(1) + " "
			else:
				line = line + str(0) + " "
			
		line = line + "|\n"
	print(line)
	
func smoothenMap():
	for i in range(Map.mapSize):
		if(!filled[i]):
			finalMap.mapArray[i].type = Map.impassableTile
			
func createRealMap():
	var tileConverter : TileConverter = TileConverter.new()
	#unsort map
	var gridMap : Array[int] = []
	#sort map index
	var indexMap : Array[int]
	indexMap.resize(Map.maxColumnNumber * Map.maxRowNumber * roomSize * roomSize)
	#upscale map
	for i in range(finalMap.mapArray.size()):
		var partialMap : Array[int] = tileConverter.tileToGridMap(finalMap.mapArray[i], roomSize)
		gridMap.append_array(partialMap)
	var curBlock : int = 0
	for tileRow in range(Map.maxRowNumber):
		for tileColumn in range(Map.maxColumnNumber):
			for blockRow in range(roomSize):
				for blockColumn in range(roomSize):
					var line : int = roomSize * Map.maxColumnNumber
					var validIndex : int = blockColumn + (blockRow * line) + (tileColumn * roomSize) + (tileRow * roomSize * line)
					indexMap[validIndex] = curBlock
					curBlock = curBlock + 1
	#bounded map
	realMap.clear()
	realMap.resize(indexMap.size())
	for i in range(indexMap.size()):
		realMap[i] = gridMap[indexMap[i]]
	print(realMap)

func indexToXZ(index: int) -> Array[int]:
	var arrayRealIndex : Array[int] = [-1, -1]
	#row
	arrayRealIndex[1] = index / (Map.maxRowNumber * roomSize)
	#column
	arrayRealIndex[0] = index - (arrayRealIndex[1] * Map.maxRowNumber * roomSize)
	return arrayRealIndex

func createGridMap():
	var ss : String = ""
	var playMap : GridMap = GridMap.new()
	playMap.mesh_library = meshLib
	playMap.cell_size = Vector3(1,1,1)
	for j in range(roomSize * Map.maxRowNumber):
		for i in range(roomSize * Map.maxColumnNumber):
			var tile = realMap[i + (j * roomSize * Map.maxColumnNumber)]
			ss = ss + str(tile) + " "
			if(tile == 0):
				playMap.set_cell_item(Vector3(i, 0, j), 2)
				playMap.set_cell_item(Vector3(i, 1, j), 2)
			elif (tile == 1):
				playMap.set_cell_item(Vector3(i, 0, j), 0)
			elif (tile == 2):
				playMap.set_cell_item(Vector3(i, 0, j), 1)
		ss = ss + "\n"
	print(ss)
	ownerNode.add_child(playMap)
	
func spawnPlayer() -> Vector3:
	var playerPosition : Array[int] = indexToXZ(spawnPoint)
	return Vector3(playerPosition[0] + 0.5, 1.5, playerPosition[1] + 0.5)
