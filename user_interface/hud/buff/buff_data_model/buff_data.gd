extends Resource

class_name BuffData


var buffName : String
var buffTexture : Texture
var currentLevel : int = 1
var maxLevel : int
var buffLevelData : Dictionary 

# Get property value of buff by buff key input
func getBuffPropertyValue(buffKey : String):
	if buffLevelData.has(currentLevel):
		var currentBuffLevel : Dictionary = buffLevelData[currentLevel]
		if currentBuffLevel.has(buffKey):
			return currentBuffLevel[buffKey] 
		else:
			return null

# Upgrade buff level by 1
func upgradeBuffLevel():
	if currentLevel < maxLevel:
		currentLevel += 1

func getNextLevelBuffDescription():
	if buffLevelData.has(currentLevel + 1):
		var currentBuffLevel : Dictionary = buffLevelData[currentLevel + 1]
		if currentBuffLevel.has(DictionaryKey.description):
			return currentBuffLevel[DictionaryKey.description] 
		else:
			return null
