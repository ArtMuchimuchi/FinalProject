extends TraitData
class_name MaxHPTrait

func _init():
	traitName = "Max HP Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 500,
			DictionaryKey.description : "Increase max hp by 25%",
			DictionaryKey.maxHP : 0.25,
		},
		2 : {
			DictionaryKey.price : 1000,
			DictionaryKey.description : "Increase max hp by 50%",
			DictionaryKey.maxHP : 0.5,
		}
	}
