extends Node

# Exp reward
var currentLevel : int = ConstantNumber.defaultPlayerLevel
var currentEXP : int = ConstantNumber.defaultPlayerExp
var roomNode : Node
var isRewarding : bool = false
var rewardStack : int = 0
var nextLevelEXP : int
# Coin reward
var currentCoin : int = 0
var saverLoader := SaverLoader.new()
var player : Entity

signal expIncreased(currentEXP : int ,nextLevelExp : int ,currentLevel : int)
signal currentCoinChanged

func _ready():
	var savedCoinData = saverLoader.loadCoinData()
	if savedCoinData :
		var coinDataDict : Dictionary = savedCoinData
		if coinDataDict.has(DictionaryKey.currentCoin):
			currentCoin = coinDataDict[DictionaryKey.currentCoin]

func setRoomNode(ownerNode:Node):
	roomNode = ownerNode
	player = roomNode.find_child("Player")

func increaseExp(expAmount:int):
	currentEXP += expAmount
	checkLevelUp()

func getNextLevelExp():
	nextLevelEXP = 15 * (currentLevel + 1)
	return nextLevelEXP

func increaseCoin(coinAmount):
	currentCoin += coinAmount
	currentCoinChanged.emit()
	saverLoader.saveCoinData(currentCoin)

func descreaseCoin(coinAmount):
	currentCoin -= coinAmount
	currentCoinChanged.emit()
	saverLoader.saveCoinData(currentCoin)



# Check if player level uo
func checkLevelUp():
	# Check if current exp enough to level up
	if currentEXP >= nextLevelEXP:
		var differenceOfEXP = currentEXP - nextLevelEXP
		currentEXP = differenceOfEXP
		currentLevel += 1
		# If player level up but buff selection doesn't show yet, add buff selection
		if isRewarding == false:
			getLevelUpReward()
		# If level up more than one level then add level up stack, so player can select another buff selection 
		else:
			rewardStack += 1
			checkLevelUp()
	# Check if player have level up stack and buff selection doesn't show yet, add buff selection
	if isRewarding == false && rewardStack > 0:
		getLevelUpReward()
	# Update exp bar in hud for both current level and  exp 
	expIncreased.emit(currentEXP,getNextLevelExp(),currentLevel)

# Add buff selection window and add another one if player have level up stack  
func getLevelUpReward():
	var buffSelectionScene = preload("res://user_interface/menu/buff_selection_menu/buff_selection_menu.tscn")
	var buffSelectionInstance = buffSelectionScene.instantiate()
	var canvasLayerNode = roomNode.get_node("CanvasLayer")
	canvasLayerNode.add_child(buffSelectionInstance)
	# When buff selection menu is showing, set reward state to true
	isRewarding = true
	# Pause game when buff selection menu is showing
	get_tree().paused = true
	# Await until player pressed select buff
	await  buffSelectionInstance.tree_exited
	# Heal player when level up each time
	var healingAmount = player.healthPoint.maxHP * ConstantNumber.healingPerLevelUp
	player.healthPoint.increaseHP(healingAmount)
	# After buff selection menu dissappear, set reward state to false
	isRewarding = false
	# Loop to check if player currently have reward stack and buff selection menu doesn't show
	while rewardStack > 0  && isRewarding == false:
		# If have reward stack, check if player still have exp to level up again
		checkLevelUp()
		rewardStack -= 1
	# Unpause when player don't have anymore level up and reward state is false 
	if rewardStack == 0  && isRewarding == false:
		unPauseRoom()

# Un pause 
func unPauseRoom():
	get_tree().paused = false

# Reset player level and exp 
func resetLevel():
	currentLevel = ConstantNumber.defaultPlayerLevel
	currentEXP = ConstantNumber.defaultPlayerExp
