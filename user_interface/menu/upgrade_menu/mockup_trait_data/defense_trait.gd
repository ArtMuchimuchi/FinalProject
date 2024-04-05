extends TraitData
class_name DefenseTrait

func _init():
	traitName = "Defense Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 500,
			DictionaryKey.description : "Increase defense by 25%",
			DictionaryKey.defense : 0.25,
		},
		2 : {
			DictionaryKey.price : 1000,
			DictionaryKey.description : "Increase defense by 50%",
			DictionaryKey.defense : 0.5,
		}
	}
