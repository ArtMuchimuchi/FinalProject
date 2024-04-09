extends TraitData
class_name AttackTrait

func _init():
	traitName = "Attack Trait"
	traitTexture = preload("res://icon.svg")
	maxLevel = 2
	traitLevelData = {
		1 : {
			DictionaryKey.price : 500,
			DictionaryKey.description : "Increase melee and range attack by 20%",
			DictionaryKey.meleeAttackDamage : 0.2,
			DictionaryKey.rangeAttackDamage : 0.2
		},
		2 : {
			DictionaryKey.price : 1000,
			DictionaryKey.description : "Increase melee and range attack by 40%",
			DictionaryKey.meleeAttackDamage : 0.4,
			DictionaryKey.rangeAttackDamage : 0.4
		}
	}
