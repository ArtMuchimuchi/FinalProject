extends MarginContainer

@onready var upgrade_slot_detail = %UpgradeSlotDetail
@onready var current_description_label = %CurrentDescriptionLabel
@onready var next_description_label = %NextDescriptionLabel
@onready var price = %Price
@onready var upgrade_button = %UpgradeButton
@onready var next_level = %NextLevel
var next_level_price : int 
var upgrade_slot : Slot
# Boolean variable to check if slot level is max 
var is_max_level : bool
signal pressed_upgrade(price:int, upgrade_slot:Slot)

# Function to set slot detail data such as slot, current level, next level description, price and upgrade button
func set_slot_detail_data(selected_slot : Slot):
	# Assign selected slot to local upgrade slot to be used in pressed upgrade signal 
	upgrade_slot = selected_slot
	upgrade_slot_detail.set_slot_data(selected_slot)
	var max_level = selected_slot.slot_level.size()
	var current_level = selected_slot.current_level
	# Check if current level is equal to or below max level to assign current level, next level description 
	if current_level < max_level:
		# If current level is zero, current level description will show "None" text 
		if current_level == ConstantNumber.slotLevelZero:
			current_description_label.text = "None"
		# If current level is more than zero, current level description will show current slot level description
		else:
			current_description_label.text = selected_slot.slot_level[current_level - ConstantNumber.currentSlotLevelIndexDifferent].description
		next_description_label.text = selected_slot.slot_level[current_level].description
		next_level_price = selected_slot.slot_level[current_level].price
		price.text = str(next_level_price)
		is_max_level = false
		
	elif current_level == max_level:
		current_description_label.text = selected_slot.slot_level[current_level - ConstantNumber.currentSlotLevelIndexDifferent].description
		is_max_level = true

	toggle_upgrade_max_level(is_max_level)

# Function to toggle  show next level, make upgrade button unclickable, not show price text if slot level is max 
func toggle_upgrade_max_level(is_max_level:bool):
	if is_max_level:
		next_level.visible = false
		price.visible = false
		upgrade_button.text = "Maxed Level"
		upgrade_button.disabled = true
	else:
		next_level.visible = true
		price.visible = true
		upgrade_button.text = "Upgrade"
		upgrade_button.disabled = false

# Function to send signal when upgrade button is pressed
func _on_upgrade_button_pressed():
	if next_level_price:
		pressed_upgrade.emit(next_level_price,upgrade_slot)
		
