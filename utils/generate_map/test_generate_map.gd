extends Node3D

@onready var thisNode = get_node(".")
@onready var meshLib = load("res://demo.meshlib")

const roomSize : int = 3

func  _ready():
	#var mapGenerator = load("res://utils/generate_map/generate_map.gd")
	#var map: Array[Array] = [[3,1,1],[1,1,1],[1,1,1]]
	#var griMap = GridMap.new()
	#mapGenerator.createMap(map, griMap, mesh_lib)
	#thisNode.add_child(griMap)
	
	#gen map
	var ga = GeneticAlgorithm.new()
	var finalMap = ga.getMap()
	
	var tileConverter : TileConverter = TileConverter.new()
	#unsort map
	var gridMap : Array[int] = []
	#
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
	var ss : String = ""
	var playMap : GridMap = GridMap.new()
	playMap.mesh_library = meshLib
	playMap.cell_size = Vector3(1,1,1)
	for j in range(roomSize * Map.maxRowNumber):
		for i in range(roomSize * Map.maxColumnNumber):
			var tile = gridMap[indexMap[i + (j * roomSize * Map.maxColumnNumber)]]
			ss = ss + str(tile) + " "
			if(tile == 0):
				playMap.set_cell_item(Vector3(i, 0, j), -1)
			elif (tile == 1):
				playMap.set_cell_item(Vector3(i, 0, j), 0)
			elif (tile == 2):
				playMap.set_cell_item(Vector3(i, 0, j), 0)
		ss = ss + "\n"
	print(ss)
	thisNode.add_child(playMap)
