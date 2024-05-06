extends BuffData

class_name MaxHPBuff

func _init():
	buffName = "MaxHP Buff"
	buffTexture = preload("res://icon.svg")
	maxLevel = 3
	buffLevelData = {
		1 : {
			DictionaryKey.description : "Increase max hp by 20%",
			DictionaryKey.maxHP : 0.2,
		},
		2 : {
			DictionaryKey.description : "Increase max hp by 35%",
			DictionaryKey.maxHP : 0.35,
		},
		3 : {
			DictionaryKey.description : "Increase max hp by 50%",
			DictionaryKey.maxHP : 0.5,
		}
	}
