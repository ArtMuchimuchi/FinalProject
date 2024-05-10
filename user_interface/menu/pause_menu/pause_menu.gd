extends Control

@onready var pauseMenuMarginContainer = %MarginContainer
@onready var optionsMenu = %OptionsMenu
@onready var resumeButton = %ResumeButton
@onready var restartButton = %RestartButton
@onready var mainMenuButton = %MainMenuButton
@onready var optionsButton = %OptionsButton
@onready var mainMenuConfirmation = %MainMenuConfirmation
@onready var restartConfirmation = %RestartConfirmation

# Called when the node enters the scene tree for the first time.
func _ready():
	optionsMenu.connect("backOptionsMenu",onPressedBackOptionsMenu)
	mainMenuConfirmation.connect("modalAccepted",onAcceptedMainMenuConfirmation)
	mainMenuConfirmation.connect("modalClosed",onClosedMainMenuConfirmation)
	restartConfirmation.connect("modalAccepted",onAcceptedRestartConfirmation)
	restartConfirmation.connect("modalClosed",onClosedRestartConfirmation)
	

# Pause Menu Button Functions 
func onPressedResumeButton():
	get_tree().paused = false
	hide()

func onPressedRestartButton(): 
	restartConfirmation.show()

func onPressedOptionsButton():
	pauseMenuMarginContainer.hide()
	optionsMenu.show()

func onPressedMainMenuButton():
	mainMenuConfirmation.show()

# Pressed back in options menu
func onPressedBackOptionsMenu():
	pauseMenuMarginContainer.show() 
	optionsMenu.hide()


# Accept and close main menu confirmation modal 
func onAcceptedMainMenuConfirmation():
	RewardManager.resetLevel()	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://user_interface/menu/main_menu/main_menu.tscn")
	
func onClosedMainMenuConfirmation():
	mainMenuConfirmation.hide()


# Accept and close restart confirmation modal 
func onAcceptedRestartConfirmation():
	RewardManager.resetLevel()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mock_room/mock_room.tscn")


func onClosedRestartConfirmation():
	restartConfirmation.hide()
