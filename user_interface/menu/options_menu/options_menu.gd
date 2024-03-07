extends Control


signal backOptionsMenu


#Emit signal after pressed back button 
func onBackButtonPressed():
	backOptionsMenu.emit()


