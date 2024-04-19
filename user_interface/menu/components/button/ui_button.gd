extends Button

class_name UIButton

@export_enum("normal","upgrade") var buttonType : String = "normal"

func _pressed():
	var buttonSoundEffect : AudioStream
	if buttonType == "normal":
		buttonSoundEffect = preload("res://audio/sound_effect/user_interface/click_sfx.wav")
	elif buttonType == "upgrade":
		buttonSoundEffect = preload("res://audio/sound_effect/user_interface/purchase_sfx.wav")
	if buttonSoundEffect:
		SoundEffectManager.playSoundEffect(self,buttonSoundEffect)
	
