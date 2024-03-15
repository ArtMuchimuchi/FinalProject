extends BuffData

class_name MovementSpeedBuff

func _init():
	buffName = "MovemetSpeed Buff"
	buffTexture = preload("res://icon.svg")
	maxLevel = 2
	buffLevelData = {
		1 : {
			DictionaryKey.description : "Increase movement speed  by 20%",
			DictionaryKey.movementSpeed : 0.2,
		},
		2 : {
			DictionaryKey.description : "Increase movement speed by 35%",
			DictionaryKey.movementSpeed : 0.35,
		}
	}
