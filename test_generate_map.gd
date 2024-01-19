extends Node3D

@onready var thisNode = get_node(".")
@onready var mesh_lib = load("res://demo.meshlib")

func  _ready():
	var mapGenerator = preload("res://generate_map.gd")
	var map: Array[Array] = [[3,1,1],[1,1,1],[1,1,1]]
	var gridMap = GridMap.new()
	mapGenerator.createMap(map, gridMap, mesh_lib)
	thisNode.add_child(gridMap)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func createMap(gridMap : GridMap):
	for i in range(-5,6):
		for j in range(-5,6):
			if(i == j):
				gridMap.set_cell_item(Vector3(i,0,j),0)
