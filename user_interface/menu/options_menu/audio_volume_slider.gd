extends HSlider

# The name of bus that we will used volume slider for 
@export var bus_name : String
# To change the volume of bus, we will need to get index of bus by finding index with bus name 
var bus_index : int 

func _ready():
	# Find bus index with bus name 
	bus_index = AudioServer.get_bus_index(bus_name)
	# Make changed volume remain even when access in another scene
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))





func _on_value_changed(changed_value):
	# Set new bus volume by specify bus index and the volume value
	AudioServer.set_bus_volume_db(
		bus_index,
		# Convert value to decibel
		linear_to_db(changed_value)
	)
