extends Node3D

@onready var thisNode = get_node(".")
@onready var mesh_lib = load("res://demo.meshlib")

func  _ready():
	var mapGenerator = load("res://utils/generate_map/generate_map.gd")
	var map: Array[Array] = [[3,1,1],[1,1,1],[1,1,1]]
	var gridMap = GridMap.new()
	mapGenerator.createMap(map, gridMap, mesh_lib)
	thisNode.add_child(gridMap)
