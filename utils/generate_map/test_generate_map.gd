extends Node3D

@onready var thisNode = get_node(".")
@onready var mesh_lib = load("res://demo.meshlib")

const roomSize : int = 1

func  _ready():
	#var mapGenerator = load("res://utils/generate_map/generate_map.gd")
	#var map: Array[Array] = [[3,1,1],[1,1,1],[1,1,1]]
	#var gridMap = GridMap.new()
	#mapGenerator.createMap(map, gridMap, mesh_lib)
	#thisNode.add_child(gridMap)
	
	#var tileConverter : TileConverter = TileConverter.new()
	#var gridMap : Array[int] = []
	#var indexMap : Array[int]
	#indexMap.resize(Map.maxColumnNumber * Map.maxRowNumber * roomSize * roomSize)
	#for i in range(sketchMap.mapArray.size()):
	#	var partialMap : Array[int] = tileConverter.tileToGridMap(sketchMap.mapArray[i], roomSize)
	#	gridMap.append_array(partialMap)
	#var curBlock : int = 0
	#for tileRow in range(Map.maxRowNumber):
	#	for tileColumn in range(Map.maxColumnNumber):
	#		for blockRow in range(roomSize):
	#			for blockColumn in range(roomSize):
	#				var line : int = roomSize * Map.maxColumnNumber
	#				var validIndex : int = blockColumn + (blockRow * line) + (tileColumn * roomSize) + (tileRow * roomSize * line)
	#				indexMap[validIndex] = curBlock
	#				curBlock = curBlock + 1
	#var ss : String = ""
	#for j in range(roomSize * Map.maxRowNumber):
	#	for i in range(roomSize * Map.maxColumnNumber):
	#		ss = ss + str(gridMap[indexMap[i + (j * roomSize * Map.maxColumnNumber)]]) + " "
	#	ss = ss + "\n"
	#print(ss)
	var ga = GeneticAlgorithm.new()
	ga.a()

