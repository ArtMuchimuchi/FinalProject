extends TraitData
class_name MaxHPTrait

func _init():
	traitName = "Max HP Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 500,
			DictionaryKey.description : "Increase melee and range attack by 15%",
			DictionaryKey.maxHP : 0.25,
		},
		2 : {
			DictionaryKey.price : 1000,
			DictionaryKey.description : "Increase melee and range attack by 30%",
			DictionaryKey.maxHP : 0.5,
		}
	}
