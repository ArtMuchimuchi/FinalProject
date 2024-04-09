extends MarginContainer

@onready var upgradeSlotDetail = %UpgradeSlotDetail
@onready var currentDescriptionLabel = %CurrentDescriptionLabel
@onready var nextDescriptionLabel = %NextDescriptionLabel
@onready var price = %Price
@onready var upgradeButton = %UpgradeButton
@onready var nextLevel = %NextLevel
var nextLevelPrice : int 
var upgradeSlot : TraitData
# Boolean variable to check if slot level is max 
var isMaxLevel : bool
signal pressedUpgrade(price:int, upgradeSlot:TraitData)

# Function to set slot detail data such as slot, current level, next level description, price and upgrade button
func setSlotDetailData(selectedSlot : TraitData):
	# Assign selected slot to local upgrade slot to be used in pressed upgrade signal 
	upgradeSlot = selectedSlot
	upgradeSlotDetail.setSlotData(selectedSlot)
	var maxLevel = selectedSlot.maxLevel
	var currentLevel = selectedSlot.currentLevel
	# Check if current level is equal to or below max level to assign current level, next level description 
	if currentLevel < maxLevel:
		# If current level is zero, current level description will show "None" text 
		if currentLevel == ConstantNumber.defaultTraitLevel:
			currentDescriptionLabel.text = "None"
		# If current level is more than zero, current level description will show current slot level description
		else:
			currentDescriptionLabel.text = selectedSlot.traitLevelData[currentLevel][DictionaryKey.description]
		var nextLevel = currentLevel + ConstantNumber.nextTraitLevel
		nextDescriptionLabel.text = selectedSlot.traitLevelData[nextLevel][DictionaryKey.description]
		nextLevelPrice = selectedSlot.traitLevelData[nextLevel][DictionaryKey.price]
		price.text = str(nextLevelPrice)
		isMaxLevel = false
		
	elif currentLevel == maxLevel:
		currentDescriptionLabel.text = selectedSlot.traitLevelData[currentLevel][DictionaryKey.description]
		isMaxLevel = true

	toggleUpgradeMaxLevel(isMaxLevel)

# Function to toggle  show next level, make upgrade button unclickable, not show price text if slot level is max 
func toggleUpgradeMaxLevel(isMaxLevel:bool):
	if isMaxLevel:
		nextLevel.visible = false
		price.visible = false
		upgradeButton.text = "Maxed Level"
		upgradeButton.disabled = true
	else:
		nextLevel.visible = true
		price.visible = true
		upgradeButton.text = "Upgrade"
		upgradeButton.disabled = false

# Function to send signal when upgrade button is pressed
func onUpgradeButtonPressed():
	if nextLevelPrice:
		pressedUpgrade.emit(nextLevelPrice,upgradeSlot)
		
