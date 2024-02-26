extends MarginContainer

@onready var name_label = %NameLabel
@onready var icon_texture = %IconTexture
@onready var level_label = %LevelLabel
signal selected_slot(slot_index:int)


# Function to set slot data such as name, level, icon texture in slot
func set_slot_data(slot_data: TraitSlotData):
	name_label.text = slot_data.name
	icon_texture.texture = slot_data.texture
	var current_level = str(slot_data.current_level)
	var max_level = str(slot_data.slot_level.size())
	level_label.text = current_level + " / " + max_level 

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
					var slot_index = get_index()
					selected_slot.emit(slot_index)
