extends Resource

class_name TraitSlotData

@export var name : String = ""
@export var texture : Texture
@export var current_level : int = 0
@export var slot_level : Array[TraitSlotLevelData]

func upgrade_level():
	current_level += 1
