extends TraitData
class_name RebirthTrait

func _init():
	traitName = "Rebirth Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 1500,
			DictionaryKey.description : "Gain extra 1 life, rebirth with 50% of health point after death",
			DictionaryKey.rebirthPoint : 1,
			DictionaryKey.rebirthHP : 0.5,
		},
		2 : {
			DictionaryKey.price : 2500,
			DictionaryKey.description : "Gain extra 1 life, rebirth with 70% of health point after death",
			DictionaryKey.rebirthPoint : 1,
			DictionaryKey.rebirthHP : 0.7,
		}
	}
