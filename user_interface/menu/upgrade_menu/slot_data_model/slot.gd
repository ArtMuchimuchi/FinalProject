extends Resource

class_name Slot

@export var name : String = ""
@export var texture : Texture
@export var current_level : int = 0
@export var slot_level : Array[SlotLevel]

func upgrade_level():
	current_level += 1
