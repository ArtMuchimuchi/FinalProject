extends Node

class_name SaverLoader

const savedTraitSlotArrayPath : String = "res://user_interface/menu/upgrade_menu/saved_trait_slot_array.json"

# Function to save trait slot array data like current level
func saveTraitArray(traitArrayData : Array[TraitData]):
	var traitArrayFile = FileAccess.open(savedTraitSlotArrayPath,FileAccess.WRITE)
	# Create dictonary which has trait slot array 
	var traitArrayDict : Dictionary = {
		"traitSlotArray" : []
	}
	
	# For loop to add trait slot data into array dictionary
	for traitData in traitArrayData:
		# Create dictionary for trait slot data which include name and current level 
		var traitSlotDict : Dictionary = {
			"traitName": traitData.traitName,
			"currentLevel" : traitData.currentLevel
		}
		# Add trait slot data dictionary into trait slot array data dictionary
		traitArrayDict["traitSlotArray"].append(traitSlotDict)
	
	# Convert dictionary into json and save data into file
	var traitArrayJson = JSON.stringify(traitArrayDict)
	traitArrayFile.store_string(traitArrayJson)
	traitArrayFile.close()


# Function to load saved file to trait slot array data
func loadTraitArray(traitArrayData : Array[TraitData]):
	# Read the trait slot array file
	var traitArrayFile = FileAccess.open(savedTraitSlotArrayPath,FileAccess.READ)
	# If trait slot array file exist, assign saved current level to each slot 
	if FileAccess.file_exists(savedTraitSlotArrayPath):
		var traitArrayJson = traitArrayFile.get_as_text() 
		var savedTraitArrayData = JSON.parse_string(traitArrayJson)
		# Assign saved current level to each trait slot data in array with same name 
		for savedTraitData in savedTraitArrayData["traitSlotArray"]:
			for traitData in traitArrayData:
				# Check if trait slot data name is same as saved name to update current level value
				if traitData.traitName == savedTraitData["traitName"]:
					traitData.currentLevel = savedTraitData["currentLevel"]
		return traitArrayData
	# If file doesn't exist return null so trait slot array data won't be loaded
	else:
		return null


