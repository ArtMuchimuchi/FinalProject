extends Node

@onready var loadingScreen = preload("res://user_interface/loading_screen/loading_screen.tscn")


func loadScene(scenePath:String):
	var loadingSceneInstance = loadingScreen.instantiate()
	loadingSceneInstance.setLoadingPath(scenePath)
	get_tree().root.add_child(loadingSceneInstance)
	var currentScene = get_tree().current_scene
	get_tree().current_scene = loadingSceneInstance
	currentScene.queue_free()
