extends Control

@onready var main_menu_margin_container = $MarginContainer
@onready var options_menu = $OptionsMenu
@onready var upgrade_menu = $UpgradeMenu


func _ready():
	# Connect signal of pressed back button in option menu
	options_menu.back_options_menu.connect(_on_back_options_menu)
	# Connect signal of pressed closed button in upgrade menu	
	upgrade_menu.closed_upgrade_menu.connect(_on_closed_upgrade_menu)
	

func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://mock_scene.tscn")


func _on_upgrade_button_pressed():
	main_menu_margin_container.visible = false
	upgrade_menu.visible = true


func _on_options_button_pressed():
	main_menu_margin_container.visible = false
	options_menu.visible = true


func _on_back_options_menu():
	main_menu_margin_container.visible = true
	options_menu.visible = false

func _on_closed_upgrade_menu():
	main_menu_margin_container.visible = true
	upgrade_menu.visible = false
