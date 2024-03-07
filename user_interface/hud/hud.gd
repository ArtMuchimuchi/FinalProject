extends Control

@onready var healthPointBar = get_node("MarginContainer/HealthPointBar")
@onready var player = get_node("../../Player")
@onready var buffGrid = get_node("MarginContainer/BuffGrid")
@onready var floorLevelLabel = get_node("MarginContainer/FloorLevelLabel")
@onready var buffScene = preload("res://user_interface/hud/buff/buff.tscn")
const buff1 = preload("res://user_interface/hud/buff/mockup_buff_data/buff_1.tres")


func _ready():
	# Connect currentHP_changed signal from player scene to HUD and update health func.
	player.connect("currentHPChanged",updateHealthPointBar)
	# Add mockup buff1  data
	updateBuffGrid(buff1)

# Update health point bar of current health
func updateHealthPointBar(currentHP : int):
	healthPointBar.updateCurrentHealth(currentHP)

# Update floor level label
func updateFloorLevel(floorLevel : int):
	floorLevelLabel.text = str(floorLevel)

# Add selected buff inside BuffGrid to show updated buff data
func updateBuffGrid(buffData : BuffData):
	var buffInstance = buffScene.instantiate()
	buffGrid.add_child(buffInstance)
	# Set buff icon, level and description
	buffInstance.setBuffData(buffData)
