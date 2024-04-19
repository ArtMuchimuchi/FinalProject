extends Node

class_name TraitManager

var saverLoader = SaverLoader.new()
var activeTraits : Array[TraitData] = []
var rebirthTrait : RebirthTrait 
var rebirthPoint : int = 0
var availableTraits : Array[TraitData] = [
	AttackTrait.new(),
	MaxHPTrait.new(),
	DefenseTrait.new(),
	MovementSpeedTrait.new(),
	RebirthTrait.new(),
]
var ownerNode : Entity


func _init(targetNode:Entity):
	ownerNode = targetNode
	# load saved trait array from saved files
	var savedTraitArray = saverLoader.loadTraitArray(availableTraits)
	if savedTraitArray != null:
		activeTraits = savedTraitArray
	var foundRebirthTrait = findExistedTrait(RebirthTrait.new())
	# Check if rebirth trait exist and current level is not zero
	if foundRebirthTrait != null && foundRebirthTrait.currentLevel != ConstantNumber.defaultTraitLevel:
		rebirthTrait = foundRebirthTrait
		rebirthPoint = rebirthTrait.getTraitPropertyValue(DictionaryKey.rebirthPoint) 

# Find if input trait data exist in active traits and return if it exist
func findExistedTrait(traitData:TraitData)-> TraitData :
	var foundTrait = null
	# Check if a trait with the same name already exists
	for activeTrait in activeTraits:
		if activeTrait.traitName == traitData.traitName:
			foundTrait = activeTrait
			break
	return foundTrait

# Get total stat percentage of input stat type from active traits
func getStatPercentage(statType : String):
	var totalStatPercentage : float = 0.0 
	for activeTrait in activeTraits:
		var statTypePercentage = activeTrait.getTraitPropertyValue(statType)
		if statTypePercentage != null:
			totalStatPercentage += statTypePercentage
	return totalStatPercentage

