extends Control

@onready var healthPointBar = get_node("MarginContainer/BottomLeft/HealthPointBar")
@onready var experienceBar = get_node("MarginContainer/BottomLeft/ExperienceBar")               
@onready var player = get_node("../../Player")
@onready var buffGrid = get_node("MarginContainer/BuffGrid")
@onready var floorLevelLabel = get_node("MarginContainer/FloorLevelLabel")
@onready var currentCoin = get_node("MarginContainer/CurrentCoin")
@onready var buffScene = preload("res://user_interface/hud/buff/buff.tscn")
@onready var activeBuffs : Array[BuffData] = []


func _ready():
	# Connect currentHP_changed signal from player scene to HUD and update health func.
	updateHealthPointBar(player.healthPoint.currentHP,player.healthPoint.maxHP)
	updateExpericeBar(RewardManager.currentEXP,RewardManager.getNextLevelExp(),RewardManager.currentLevel)
	updateCurrentCoin()
	updateBuffGrid(player.buffManager.activeBuffs)
	player.connect("hpChanged",updateHealthPointBar)
	player.connect("activeBuffsUpdated",updateBuffGrid)
	RewardManager.connect("expIncreased",updateExpericeBar)
	RewardManager.connect("currentCoinChanged",updateCurrentCoin)
	
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

func updateExpericeBar(currentExp : int,nextLevelExp : int, currentLevel : int):
	experienceBar.updateCurrentEXPAndLevel(currentExp,nextLevelExp,currentLevel)

func updateCurrentCoin():
	currentCoin.updateCurrentCoin()
