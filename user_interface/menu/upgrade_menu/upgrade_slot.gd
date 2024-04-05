extends MarginContainer

@onready var nameLabel = %NameLabel
@onready var iconTexture = %IconTexture
@onready var levelLabel = %LevelLabel
signal selectedSlot(slotIndex:int)


# Function to set slot data such as name, level, icon texture in slot
func setSlotData(traitData: TraitData):
	nameLabel.text = traitData.traitName
	iconTexture.texture = traitData.traitTexture
	var currentLevel = str(traitData.currentLevel)
	var maxLevel = str(traitData.maxLevel)
	levelLabel.text = currentLevel + " / " + maxLevel 

# Function to respond when slot was clicked, send signal of slot index 
func _on_gui_input(event):
		# Check if user left click on slot
		if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed():
			# send signal if slot inside grid container
			var parent = get_parent()
			if parent :
				if parent is GridContainer:
					var slotIndex = get_index()
					selectedSlot.emit(slotIndex)
