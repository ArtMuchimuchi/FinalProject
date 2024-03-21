extends BuffData

class_name AttackBuff

func _init():
	buffName = "Attack Buff"
	buffTexture = preload("res://icon.svg")
	maxLevel = 2
	buffLevelData = {
		1 : {
			DictionaryKey.description : "Increase melee and range attack by 15%",
			DictionaryKey.meleeAttackDamage : 0.25,
			DictionaryKey.rangeAttackDamage : 0.25
		},
		2 : {
			DictionaryKey.description : "Increase melee and range attack by 30%",
			DictionaryKey.meleeAttackDamage : 0.5,
			DictionaryKey.rangeAttackDamage : 0.5
		}
	}
