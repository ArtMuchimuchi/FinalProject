extends Control

var progress : Array[float] = []
var sceneLoadStatus : int = 0
var scenePath : String 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Make request to load scene so we can check status of loading   
	ResourceLoader.load_threaded_request(scenePath)


# Change loading screen to scene path when finished loading
func _process(delta):
	# Check loading status if finished it will changed from loading screen to new scene
	sceneLoadStatus = ResourceLoader.load_threaded_get_status(scenePath,progress)
	if sceneLoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
		var loadedScene : PackedScene = ResourceLoader.load_threaded_get(scenePath) 
		var newScence = loadedScene.instantiate()
		var currentScene = get_tree().current_scene
		get_tree().root.add_child(newScence)
		get_tree().current_scene = newScence
		currentScene.queue_free()
		

func setLoadingPath(loadingPath : String):
	scenePath = loadingPath
