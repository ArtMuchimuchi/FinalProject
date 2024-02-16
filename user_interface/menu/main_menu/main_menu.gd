extends Control

@onready var main_menu_margin_container = $MarginContainer
@onready var options_menu = $OptionsMenu


func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://mock_scene.tscn")


func _on_upgrade_button_pressed():
	pass


func _on_options_button_pressed():
	main_menu_margin_container.visible = false
	options_menu.visible = true


func _on_options_menu_back_options_menu():
	main_menu_margin_container.visible = true
	options_menu.visible = false
