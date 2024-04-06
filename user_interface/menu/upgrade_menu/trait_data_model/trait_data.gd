extends Resource

class_name TraitData

var traitName : String
var traitTexture : Texture
var currentLevel : int = ConstantNumber.defaultTraitLevel
var maxLevel : int
var traitLevelData : Dictionary 

# Get property value of trait by trait key input
func getTraitPropertyValue(traitKey : String):
	if traitLevelData.has(currentLevel):
		var currentTraitLevel : Dictionary = traitLevelData[currentLevel]
		if currentTraitLevel.has(traitKey):
			return currentTraitLevel[traitKey] 
		else:
			return null

# Upgrade trait level by 1
func upgradeTraitLevel():
	if currentLevel < maxLevel:
		currentLevel += 1

