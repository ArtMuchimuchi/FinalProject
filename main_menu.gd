extends Control


func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://mock_scene.tscn")


func _on_upgrade_button_pressed():
	pass


func _on_options_button_pressed():
	pass



