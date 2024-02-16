extends Control


signal back_options_menu


#Emit signal after pressed back button 
func _on_back_button_pressed():
	back_options_menu.emit()


