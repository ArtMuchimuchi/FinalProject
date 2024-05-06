extends Control

@onready var slotGrid = %SlotGrid
@onready var upgradeSlotDetail = %SlotDetail
@onready var currentCoinLabel = %CurrentCoinLabel
const upgradeSlot = preload("res://user_interface/menu/upgrade_menu/upgrade_slot.tscn")
signal closedUpgradeMenu
# Mockup trait slot array
var mockupTraitSlotArray : Array[TraitData] = [
	AttackTrait.new(),
	MaxHPTrait.new(),
	DefenseTrait.new(),
	MovementSpeedTrait.new(), 
	RebirthTrait.new(),
]
@onready var saverLoader = SaverLoader.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load saved data if there's saved trait slot array data file 
	if saverLoader.loadTraitArray(mockupTraitSlotArray) != null:
		mockupTraitSlotArray = saverLoader.loadTraitArray(mockupTraitSlotArray)
	addSlotGrid(mockupTraitSlotArray)
	updateCurrentCoin()
	setDefaultSlotDetail(mockupTraitSlotArray)
	

# Add slot slots to the grid
func addSlotGrid(slots : Array[TraitData]):
	# Remove old upgrade slots and prevent dulplicate slot when re-used function 
	for slot in slotGrid.get_children():
		slot.queue_free()
	# Add upgrade slots and set slot data inside grid
	for slot in slots:
		var slotInstance = upgradeSlot.instantiate()
		slotInstance.selectedSlot.connect(onSelecetdSlot)
		slotGrid.add_child(slotInstance)
		slotInstance.setSlotData(slot)
	
# Set slot detail default to first slot in grid 
func setDefaultSlotDetail(slots : Array[TraitData]):
		upgradeSlotDetail.setSlotDetailData(slots[ConstantNumber.defaultSlotDetailIndex],RewardManager.currentCoin)
		upgradeSlotDetail.pressedUpgrade.connect(onPressedUpgrade)

# Function to respond after user click slot, change slot detail to selected slot
func onSelecetdSlot(slotIndex:int):
	var selectedSlot = mockupTraitSlotArray[slotIndex]
	upgradeSlotDetail.setSlotDetailData(selectedSlot,RewardManager.currentCoin)

# Function to change current coin value display
func updateCurrentCoin():
	currentCoinLabel.text = "Current Coint : %s" %RewardManager.currentCoin

# Function to upgrade slot level when user pressed upgrade button
func onPressedUpgrade(price:int,slot:TraitData):
	# Check if current point is enough to upgrade level
	if RewardManager.currentCoin >= price:
		# Get the remaining current coin
		RewardManager.descreaseCoin(price)
		# Update remaining current coin
		updateCurrentCoin()
		# Upgrade level of selected slot
		slot.upgradeTraitLevel()
		# Update upgrade slot data by re-adding slots
		addSlotGrid(mockupTraitSlotArray)
		# Update slot detail in slot detail 
		upgradeSlotDetail.setSlotDetailData(slot,RewardManager.currentCoin)
		# Saved trait slot array in file when upgrade trait slot level
		saverLoader.saveTraitArray(mockupTraitSlotArray)
		


# Function to send signal when pressed closed button on upper right corner
func onCloseUpgradeMenuButtonPressed():
	closedUpgradeMenu.emit()
