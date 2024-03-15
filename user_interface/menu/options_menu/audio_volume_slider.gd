extends HSlider

# The name of bus that we will used volume slider for 
@export var busName : String
# To change the volume of bus, we will need to get index of bus by finding index with bus name 
var busIndex : int 

func _ready():
	# Find bus index with bus name 
	busIndex = AudioServer.get_bus_index(busName)
	# Make changed volume remain even when access in another scene
	value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))





func _on_value_changed(changedValue):
	# Set new bus volume by specify bus index and the volume value
	AudioServer.set_bus_volume_db(
		busIndex,
		# Convert value to decibel
		linear_to_db(changedValue)
	)
