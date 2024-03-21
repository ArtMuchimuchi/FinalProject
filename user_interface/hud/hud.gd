extends Control

@onready var healthPointBar = get_node("MarginContainer/HealthPointBar")
@onready var player = get_node("../../Player")
@onready var buffGrid = get_node("MarginContainer/BuffGrid")
@onready var floorLevelLabel = get_node("MarginContainer/FloorLevelLabel")
@onready var buffScene = preload("res://user_interface/hud/buff/buff.tscn")
@onready var activeBuffs : Array[BuffData] = []


func _ready():
	# Connect currentHP_changed signal from player scene to HUD and update health func.
	updateHealthPointBar(player.healthPoint.currentHP,player.healthPoint.maxHP)
	player.connect("hpChanged",updateHealthPointBar)
	player.connect("activeBuffsUpdated",updateBuffGrid)

# Update health point bar of current health
func updateHealthPointBar(currentHP : int,maxHP : int):
	healthPointBar.updateCurrentHealth(currentHP,maxHP)

# Update floor level label
func updateFloorLevel(floorLevel : int):
	floorLevelLabel.text = str(floorLevel)

# Add selected buff inside BuffGrid to show updated buff data
func updateBuffGrid(activeBuffs : Array[BuffData]):
	# Remove old active buffs
	for buff in buffGrid.get_children():
		buff.queue_free()
	for buffData in activeBuffs:
		var buffInstance = buffScene.instantiate()
		buffGrid.add_child(buffInstance)
		# Set buff icon, level and description
		buffInstance.setBuffData(buffData)
