extends Resource

class_name TraitData

var traitName : String
var traitTexture : Texture
var currentLevel : int = ConstantNumber.defaultTraitLevel
var maxLevel : int
var traitLevelData : Dictionary 

# Get property value of buff by buff key input
func getTraitPropertyValue(buffKey : String):
	if traitLevelData.has(currentLevel):
		var currentTraitLevel : Dictionary = traitLevelData[currentLevel]
		if currentTraitLevel.has(buffKey):
			return currentTraitLevel[buffKey] 
		else:
			return null

# Upgrade trait level by 1
func upgradeTraitLevel():
	if currentLevel < maxLevel:
		currentLevel += 1

