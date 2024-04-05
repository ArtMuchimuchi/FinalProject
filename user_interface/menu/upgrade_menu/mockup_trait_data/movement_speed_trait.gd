extends TraitData
class_name MovementSpeedTrait

func _init():
	traitName = "Movement Speed Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 500,
			DictionaryKey.description : "Increase movement speed by 10%",
			DictionaryKey.maxHP : 0.10,
		},
		2 : {
			DictionaryKey.price : 1000,
			DictionaryKey.description : "Increase movement speed by 20%",
			DictionaryKey.maxHP : 0.20,
		}
	}
