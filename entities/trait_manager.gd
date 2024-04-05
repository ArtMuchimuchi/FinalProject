extends Node

class_name TraitManager

var saverLoader = SaverLoader.new()
var activeTraits : Array[TraitData] = []
var availableTraits : Array[TraitData] = [
	AttackTrait.new(),
	MaxHPTrait.new(),
	DefenseTrait.new(),
	MovementSpeedTrait.new()
]
var ownerNode : Entity


func _init(targetNode:Entity):
	ownerNode = targetNode
	var savedTraitArray = saverLoader.loadTraitArray(availableTraits)
	if savedTraitArray != null:
		activeTraits = savedTraitArray

# Find if input trait data exist in active buffs and return if it exist
func findExistedTrait(traitData:TraitData)-> TraitData :
	var foundTrait = null
	# Check if a buff with the same name already exists
	for activeTrait in activeTraits:
		if activeTrait.traitName == traitData.traitName:
			foundTrait = activeTraits 
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

