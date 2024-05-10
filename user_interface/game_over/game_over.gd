extends Control

@onready var playAainButton = %PlayAgainButton
@onready var mainMenuButton = %MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Stop bgm and play sound effect
	BackgroundMusicManager.playing = false
	var playerDeathSFX = preload("res://audio/sound_effect/player/death_sfx.wav")
	SoundEffectManager.playSoundEffect(self,playerDeathSFX)
	RewardManager.resetLevel()

func onPlayAgainButtonPressed():
	get_tree().change_scene_to_file("res://mock_room/mock_room.tscn")

func onMainMenuButtonPressed():
	get_tree().change_scene_to_file("res://user_interface/menu/main_menu/main_menu.tscn")
