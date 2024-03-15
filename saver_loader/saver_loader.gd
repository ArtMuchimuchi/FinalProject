extends Node

class_name SaverLoader

const savedTraitSlotArrayPath : String = "res://user_interface/menu/upgrade_menu/saved_trait_slot_array.json"

# Function to save trait slot array data like current level
func saveTraitSlotArray(traitSlotArrayData : Array[TraitSlotData]):
	var traitSlotArrayFile = FileAccess.open(savedTraitSlotArrayPath,FileAccess.WRITE)
	# Create dictonary which has trait slot array 
	var traitSlotArrayDict : Dictionary = {
		"traitSlotArray" : []
	}
	
	# For loop to add trait slot data into array dictionary
	for traitSlotData in traitSlotArrayData:
		# Create dictionary for trait slot data which include name and current level 
		var traitSlotDict : Dictionary = {
			"name": traitSlotData.name,
			"currentLevel" : traitSlotData.currentLevel
		}
		# Add trait slot data dictionary into trait slot array data dictionary
		traitSlotArrayDict["traitSlotArray"].append(traitSlotDict)
	
	# Convert dictionary into json and save data into file
	var traitSlotArrayJson = JSON.stringify(traitSlotArrayDict)
	traitSlotArrayFile.store_string(traitSlotArrayJson)
	traitSlotArrayFile.close()


# Function to load saved file to trait slot array data
func loadTraitSlotArray(traitSlotArrayData : Array[TraitSlotData]):
	# Read the trait slot array file
	var traitSlotArrayFile = FileAccess.open(savedTraitSlotArrayPath,FileAccess.READ)
	# If trait slot array file exist, assign saved current level to each slot 
	if FileAccess.file_exists(savedTraitSlotArrayPath):
		var traitSlotArrayJson = traitSlotArrayFile.get_as_text() 
		var savedTraitSlotArrayData = JSON.parse_string(traitSlotArrayJson)
		# Assign saved current level to each trait slot data in array with same name 
		for savedTraitSlotData in savedTraitSlotArrayData["traitSlotArray"]:
			for traitSlotData in traitSlotArrayData:
				# Check if trait slot data name is same as saved name to update current level value
				if traitSlotData.name == savedTraitSlotData["name"]:
					traitSlotData.currentLevel = savedTraitSlotData["currentLevel"]
		return
	# If file doesn't exist return null so trait slot array data won't be loaded
	else:
		return null


