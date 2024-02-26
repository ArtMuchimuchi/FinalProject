extends Control

@onready var slot_grid = %SlotGrid
@onready var upgrade_slot_detail = %SlotDetail
@onready var current_coin_label = %CurrentCoinLabel
const upgrade_slot = preload("res://user_interface/menu/upgrade_menu/upgrade_slot.tscn")
var current_coin : int = 10000
signal closed_upgrade_menu
# Mockup trait slot array
const trait_slot_1 = preload("res://user_interface/menu/upgrade_menu/mockup_trait_slot_data/trait_slot_1.tres")
const trait_slot_2 = preload("res://user_interface/menu/upgrade_menu/mockup_trait_slot_data/trait_slot_2.tres")
var mockup_trait_slot_array : Array[TraitSlotData] = [
	trait_slot_1,
	trait_slot_2
]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_slot_grid(mockup_trait_slot_array)
	update_current_coin()
	set_slot_detail_default(mockup_trait_slot_array)
	
# Add slot slots to the grid
func add_slot_grid(slots : Array[TraitSlotData]):
	# Remove old upgrade slots and prevent dulplicate slot when re-used function 
	for slot in slot_grid.get_children():
		slot.queue_free()
	# Add upgrade slots and set slot data inside grid
	for slot in slots:
		var slot_instance = upgrade_slot.instantiate()
		slot_instance.selected_slot.connect(on_selecetd_slot)
		slot_grid.add_child(slot_instance)
		slot_instance.set_slot_data(slot)
	
# Set slot detail default to first slot in grid 
func set_slot_detail_default(slots : Array[TraitSlotData]):
		upgrade_slot_detail.set_slot_detail_data(slots[ConstantNumber.defaultSlotDetailIndex])
		upgrade_slot_detail.pressed_upgrade.connect(on_pressed_upgrade)

# Function to respond after user click slot, change slot detail to selected slot
func on_selecetd_slot(slot_index:int):
	var selected_slot = mockup_trait_slot_array[slot_index]
	upgrade_slot_detail.set_slot_detail_data(selected_slot)

# Function to change current coin value display
func update_current_coin():
	current_coin_label.text = "Current Coint : %s" %current_coin

# Function to upgrade slot level when user pressed upgrade button
func on_pressed_upgrade(price:int,slot:TraitSlotData):
	# Check if current point is enough to upgrade level
	if current_coin >= price:
		# Get the remaining current coin
		current_coin -= price
		# Update remaining current coin
		update_current_coin()
		# Upgrade level of selected slot
		slot.upgrade_level()
		# Update upgrade slot data by re-adding slots
		add_slot_grid(mockup_trait_slot_array)
		# Update slot detail in slot detail 
		upgrade_slot_detail.set_slot_detail_data(slot)
		
		


# Function to send signal when pressed closed button on upper right corner
func _on_close_upgrade_menu_button_pressed():
	closed_upgrade_menu.emit()
