extends Node3D

@onready var thisNode = get_node(".")
@onready var meshLib = load("res://texture/real.tres")
@onready var player = preload("res://player.tscn")

const roomSize : int = 3

func  _ready():
	var m = MapGenerator.new(thisNode, meshLib)
	m.getMap()
	var p = player.instantiate()
	p.position = m.spawnPlayer()
	thisNode.add_child(p)
