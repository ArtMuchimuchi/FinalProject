extends Node

func playSoundEffect(parentNode : Node, audioStream : AudioStream, volumeDB : float = 0.0 ):
	var audioStreamPlayer := AudioStreamPlayer.new()
	audioStreamPlayer.bus = "soundEffect"
	audioStreamPlayer.stream = audioStream
	audioStreamPlayer.volume_db = volumeDB
	parentNode.add_child(audioStreamPlayer)
	audioStreamPlayer.play()
	audioStreamPlayer.connect("finished", removeAudioStreamPlayer.bind(audioStreamPlayer))

func removeAudioStreamPlayer(node:Node):
	node.queue_free()

