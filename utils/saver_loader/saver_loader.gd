extends Node

class_name SaverLoader

const savedDataPath : String = "res://utils/saved_data/saved_data.json"
var defaultTraitArrayData : Array[TraitData] = [
	AttackTrait.new(),
	MaxHPTrait.new(),
	DefenseTrait.new(),
	MovementSpeedTrait.new(), 
	RebirthTrait.new(),
]


# Function to save trait slot array data and current coin
func saveData(traitArrayData : Array[Dictionary], currentCoin : int ):
	var savedDataFile = FileAccess.open(savedDataPath,FileAccess.WRITE)
	var savedDataDict = {
		"traitSlotArray" : [],
		"currentCoin" : 0,
	}
	savedDataDict[DictionaryKey.traitSlotArray] = traitArrayData
	savedDataDict[DictionaryKey.currentCoin] = currentCoin
	var savedDataJson = JSON.stringify(savedDataDict)
	savedDataFile.store_string(savedDataJson)
	savedDataFile.close()



func saveTraitArray(traitArrayData: Array[TraitData]):
	# Variable for saved trait data
	var savedTraitSlotArray : Array[Dictionary] = []
	# Check if trait array data have members () 
	if traitArrayData.size() == 0:
		traitArrayData = defaultTraitArrayData
	for traitData in traitArrayData:
		# Create dictionary for trait slot data which include name and current level 
		var traitSlotDict : Dictionary = {
			"traitName": traitData.traitName,
			"currentLevel" : traitData.currentLevel
		}
		# Add saved trait slot data dictionary into trait slot array data dictionary
		savedTraitSlotArray.append(traitSlotDict)
	
	saveData(savedTraitSlotArray,RewardManager.currentCoin)


func saveCoinData():
	var oldTraitSlotArray = loadTraitArray(defaultTraitArrayData)
	if oldTraitSlotArray.size() > 0:
		saveTraitArray(oldTraitSlotArray)
	else:
		saveTraitArray(defaultTraitArrayData)


func loadData():
	var savedDataFile = FileAccess.open(savedDataPath,FileAccess.READ)
	if FileAccess.file_exists(savedDataPath):
		var savedDataJson = savedDataFile.get_as_text()
		var savedDataDict = JSON.parse_string(savedDataJson)
		return savedDataDict
	else: 
		return null

func loadTraitArray(traitArrayData : Array[TraitData]):
	var savedDataDict = loadData()
	if savedDataDict && savedDataDict.has(DictionaryKey.traitSlotArray):
		var savedTraitDataArray = savedDataDict[DictionaryKey.traitSlotArray] 
		for savedTraitData in savedTraitDataArray:
			for traitData in traitArrayData:
				# Check if trait slot data name is same as saved name to update current level value
				if traitData.traitName == savedTraitData[DictionaryKey.traitName]:
					traitData.currentLevel = savedTraitData[DictionaryKey.currentLevel]
		return traitArrayData
	else:
		return null

func loadCoinData():
	var savedDataDict = loadData()
	if savedDataDict && savedDataDict.has(DictionaryKey.currentCoin):
		var currentCoin : int = savedDataDict[DictionaryKey.currentCoin]
		return currentCoin 
	else:
		return null 
