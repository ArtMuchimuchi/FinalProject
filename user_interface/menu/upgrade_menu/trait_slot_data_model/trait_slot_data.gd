extends Resource

class_name TraitSlotData

@export var name : String = ""
@export var texture : Texture
@export var currentLevel : int = 0
@export var slotLevel : Array[TraitSlotLevelData]

func upgradeLevel():
	currentLevel += 1
