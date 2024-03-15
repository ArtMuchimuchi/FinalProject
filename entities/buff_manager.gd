extends Node

class_name BuffManager

var activeBuffs : Array[BuffData] = []
var ownerNode : Entity


func _init(targetNode:Entity):
	ownerNode = targetNode

# Add new buff to active buff
func addNewBuff(buffData : BuffData):
		if findExistedBuff(buffData) == null:
			activeBuffs.append(buffData)
			ownerNode.emit_signal("activeBuffsUpdated",activeBuffs)
			ownerNode.emit_signal("modifyStatsFromActiveBuffs")


# Upgrade buff level of input buff data 
func upgradeBuffLevel(buffData : BuffData):
		if findExistedBuff(buffData) != null:
			var existedBuff = findExistedBuff(buffData)
			existedBuff.upgradeBuffLevel()
			ownerNode.emit_signal("activeBuffsUpdated",activeBuffs)
			ownerNode.emit_signal("modifyStatsFromActiveBuffs")

# Find if input buff data exist in active buffs and return if it exist
func findExistedBuff(buffData:BuffData)-> BuffData :
	var foundBuff = null
	# Check if a buff with the same name already exists
	for buff in activeBuffs:
		if buff.buffName == buffData.buffName:
			foundBuff = buff 
			break
	return foundBuff

# Get total stat percentage of input stat type from active buffs
func getStatPercentage(statType : String):
	var totalStatPercentage : float = 0.0 
	for buff in activeBuffs:
		var statTypePercentage = buff.getBuffPropertyValue(statType)
		if statTypePercentage != null:
			totalStatPercentage += statTypePercentage
	return totalStatPercentage
