extends BuffData

class_name DefenseBuff

func _init():
	buffName = "Defense Buff"
	buffTexture = preload("res://icon.svg")
	maxLevel = 2
	buffLevelData = {
		1 : {
			DictionaryKey.description : "Increase defense by 25%",
			DictionaryKey.defense : 0.25,
		},
		2 : {
			DictionaryKey.description : "Increase melee and range attack by 50%",
			DictionaryKey.defense : 0.5
		}
	}
