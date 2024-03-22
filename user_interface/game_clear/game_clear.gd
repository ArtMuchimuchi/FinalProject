extends Control

@onready var mainMenuButton = %MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func onMainMenuButtonPressed():
	get_tree().change_scene_to_file("res://user_interface/menu/main_menu/main_menu.tscn")
