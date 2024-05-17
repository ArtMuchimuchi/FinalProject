extends Control

@onready var mainMenuMarginContainer = $MarginContainer
@onready var optionsMenu = $OptionsMenu
@onready var upgradeMenu = $UpgradeMenu


func _ready():
	# Connect signal of pressed back button in option menu
	optionsMenu.backOptionsMenu.connect(onBackOptionsMenu)
	# Connect signal of pressed closed button in upgrade menu	
	upgradeMenu.closedUpgradeMenu.connect(onClosedUpgradeMenu)
	BackgroundMusicManager.playMenuBGM()
	# When comeback to main menu reset difficulty mode to default easy mode
	FloorManager.resetDifficultyMode()

func onQuitButtonPressed():
	get_tree().quit()


func onStartButtonPressed():
	get_tree().change_scene_to_file("res://user_interface/difficulty_selection_menu/difficulty_selection_menu.tscn")

func onUpgradeButtonPressed():
	mainMenuMarginContainer.visible = false
	upgradeMenu.visible = true


func onOptionsButtonPressed():
	mainMenuMarginContainer.visible = false
	optionsMenu.visible = true


func onBackOptionsMenu():
	mainMenuMarginContainer.visible = true
	optionsMenu.visible = false

func onClosedUpgradeMenu():
	mainMenuMarginContainer.visible = true
	upgradeMenu.visible = false
