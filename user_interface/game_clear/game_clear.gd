extends Control

@onready var mainMenuButton = %MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Stop bgm and play sound effect
	BackgroundMusicManager.playing = false
	var playerWinSFX = preload("res://audio/sound_effect/player/win_sfx.wav")
	SoundEffectManager.playSoundEffect(self,playerWinSFX)


func onMainMenuButtonPressed():
	get_tree().change_scene_to_file("res://user_interface/menu/main_menu/main_menu.tscn")
