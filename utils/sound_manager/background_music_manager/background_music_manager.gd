extends AudioStreamPlayer

var menuBGM = preload("res://audio/background_music/menu_bgm.wav")
var fightBGM = preload("res://audio/background_music/fight_bgm.wav")
# Called when the node enters the scene tree for the first time.

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func changeBackgroundMusic(BGM:AudioStream):
	stream = BGM
	play()
	

func playfightBGM():
	changeBackgroundMusic(fightBGM)

func playMenuBGM():
	changeBackgroundMusic(menuBGM)
