extends Node

class_name SaverLoader

const savedTraitSlotArrayPath : String = "res://user_interface/menu/upgrade_menu/saved_trait_slot_array.json"

# Function to save trait slot array data like current level
func save_trait_slot_array(trait_slot_array_data : Array[TraitSlotData]):
	var trait_slot_array_file = FileAccess.open(savedTraitSlotArrayPath,FileAccess.WRITE)
	# Create dictonary which has trait slot array 
	var trait_slot_array_dict : Dictionary = {
		"trait_slot_array" : []
	}
	
	# For loop to add trait slot data into array dictionary
	for trait_slot_data in trait_slot_array_data:
		# Create dictionary for trait slot data which include name and current level 
		var trait_slot_dict : Dictionary = {
			"name": trait_slot_data.name,
			"current_level" : trait_slot_data.current_level
		}
		# Add trait slot data dictionary into trait slot array data dictionary
		trait_slot_array_dict["trait_slot_array"].append(trait_slot_dict)
	
	# Convert dictionary into json and save data into file
	var trait_slot_array_json = JSON.stringify(trait_slot_array_dict)
	trait_slot_array_file.store_string(trait_slot_array_json)
	trait_slot_array_file.close()


# Function to load saved file to trait slot array data
func load_trait_slot_array(trait_slot_array_data : Array[TraitSlotData]):
	# Read the trait slot array file
	var trait_slot_array_file = FileAccess.open(savedTraitSlotArrayPath,FileAccess.READ)
	# If trait slot array file exist, assign saved current level to each slot 
	if FileAccess.file_exists(savedTraitSlotArrayPath):
		var trait_slot_array_json = trait_slot_array_file.get_as_text() 
		var saved_trait_slot_array_data = JSON.parse_string(trait_slot_array_json)
		# Assign saved current level to each trait slot data in array with same name 
		for saved_trait_slot_data in saved_trait_slot_array_data["trait_slot_array"]:
			for trait_slot_data in trait_slot_array_data:
				# Check if trait slot data name is same as saved name to update current level value
				if trait_slot_data.name == saved_trait_slot_data["name"]:
					trait_slot_data.current_level = saved_trait_slot_data["current_level"]
		return
	# If file doesn't exist return null so trait slot array data won't be loaded
	else:
		return null


