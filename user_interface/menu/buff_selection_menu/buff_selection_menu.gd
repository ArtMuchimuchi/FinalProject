extends Control

@onready var selectableBuffs = %SelectableBuffs
@onready var buffCardScene = preload("res://user_interface/menu/buff_selection_menu/buff_card/buff_card.tscn")
@onready var selectButton = %SelectButton
@onready var availableBuffs : Array[BuffData] = [
	AttackBuff.new(),
	DefenseBuff.new(),
	MaxHPBuff.new(),
	MovementSpeedBuff.new()
] 
@onready var selectableBuffDatas : Array[BuffData] = []
@onready var player = get_node("../../Player")
@onready var selectedBuffIndex : int
# Called when the node enters the scene tree for the first time.
func _ready():
	selectButton.disabled = true
	getSelectableBuffDatas(3)
	setSelectableBuffDatas(selectableBuffDatas)
	

# Fucntion to get selectable buffs for player to select
func getSelectableBuffDatas(limit:int):
	var availableBuffIndexes : Array[int] = []
	var randomBuffIndexes : Array[int] = []
	# Get player's max level buff index so it won't be randomize
	var maxLevelBuffIndexes : Array[int] = getMaxLevelBuffIndexes()
	# Set array of available buff indexes 
	for index in availableBuffs.size():
		availableBuffIndexes.append(index)
	# Remove player's max level index
	for maxLevelIndex in maxLevelBuffIndexes:
		availableBuffIndexes.erase(maxLevelIndex)
	
	# Randomize buff index 
	while randomBuffIndexes.size() < limit :
		# Randomize buff index if there remaining buff index to be select  
		if availableBuffIndexes.size() > ConstantNumber.emptyArray:
			var randomIndex = randi() % availableBuffIndexes.size()
			var indexValue = availableBuffIndexes[randomIndex]
			if not randomBuffIndexes.has(indexValue) :
					randomBuffIndexes.append(indexValue)
					availableBuffIndexes.remove_at(randomIndex)
					
		# Set buff index as -1 if available indexes run out / no buff to be select
		else:
			randomBuffIndexes.append(ConstantNumber.emptyBuffIndex)

	# Add selectable buff data into array 
	for buffIndex in randomBuffIndexes:
		# If it's non-empty index add buff data to array
		if buffIndex != ConstantNumber.emptyBuffIndex:
			# Get selectable buff that was random
			var selectableBuff = availableBuffs[buffIndex]
			var foundPlayerBuff : BuffData = player.buffManager.findExistedBuff(selectableBuff)
			# Check if player already has selectable buff, then upgrade buff level
			if foundPlayerBuff != null:
				foundPlayerBuff.upgradeBuffLevel
				selectableBuffDatas.append(foundPlayerBuff)
			else:
				selectableBuffDatas.append(selectableBuff)
		# If index is -1, add null in array
		else:
			selectableBuffDatas.append(null)
	
# Set selectable buff datas to buff card
func setSelectableBuffDatas(selectableBuffsData:Array[BuffData]):
	for buffCard in selectableBuffs.get_children():
		buffCard.queue_free()
	
	for buffData in selectableBuffsData:
		var buffCardInstance = buffCardScene.instantiate()
		selectableBuffs.add_child(buffCardInstance)
		# Check if player has this buff data
		var hasBuff : bool = false
		if buffData:
			if player.buffManager.findExistedBuff(buffData):
				hasBuff = false
		# This is buff index of available buffs, so 
		var buffIndex : int 
		if buffData != null:
			for buff in availableBuffs:
				if buff.buffName == buffData.buffName:
					buffIndex = availableBuffs.find(buff)
		buffCardInstance.setBuffCardData(buffData,hasBuff,buffIndex)
		buffCardInstance.connect("buffCardSelected",onBuffCardSelected)
		

func getMaxLevelBuffIndexes()->Array[int]:
	var playerMaxLevelBuffs : Array[BuffData] = player.buffManager.getMaxLevelBuffs()
	var playerMaxLevelBuffIndexes : Array[int] = []
	if playerMaxLevelBuffs.size() > ConstantNumber.emptyArray:
		for maxLevelbuff in playerMaxLevelBuffs:
			for availableBuff in availableBuffs:
				if maxLevelbuff.buffName == availableBuff.buffName:
					var maxLevelIndex = availableBuffs.find(availableBuff)
					playerMaxLevelBuffIndexes.append(maxLevelIndex)
	return playerMaxLevelBuffIndexes

# Toggle selection border of buff card, assign selected buff index
func onBuffCardSelected(index:int):
	selectButton.disabled = false
	var selectedBuffCard = selectableBuffs.get_child(index)
	# Toggle selection border of buff card
	for buffCard in selectableBuffs.get_children():
		buffCard.isSelected = false
		buffCard.showSelectedBorder()
	selectedBuffCard.isSelected = true
	selectedBuffCard.showSelectedBorder()
	# Assign selected buff index
	selectedBuffIndex = selectedBuffCard.buffIndex
	
# Apply buff selection to player
func onSelectButtonPressed():
	var selectedBuff = availableBuffs[selectedBuffIndex]
	var existedBuff = player.buffManager.findExistedBuff(selectedBuff)
	# If player has buff, upgrade level if player has buff
	if existedBuff:
		player.buffManager.upgradeBuffLevel(existedBuff)
	# Add new buff to player
	else:
		player.buffManager.addNewBuff(selectedBuff)
	queue_free()

