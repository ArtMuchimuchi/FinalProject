extends Node3D

@onready var thisNode = get_node("NavigationRegion3D")
@onready var meshLib = load("res://texture/real.tres")
@onready var pauseMenu = %PauseMenu
@onready var enemiesNode = $Enemies
@onready var player = $Player
@onready var mapGenerator = MapGenerator.new(thisNode, meshLib)
var generalMonkey = preload("res://entities/enemies/general_monkey/general_monkey.tscn")
var flyMonkey = preload("res://entities/enemies/fly_monkey/fly_monkey.tscn")
var zombieMonkey = preload("res://entities/enemies/zombie_monkey/zombie_monkey.tscn")
var muscleMonkey = preload("res://entities/enemies/muscle_monkey/muscle_monkey.tscn")

var enemyTypes  = [
	generalMonkey,
	flyMonkey,
	zombieMonkey,
	muscleMonkey,
] 

var exitPositionXList : Array[int]
var exitPositionZList : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	RewardManager.setRoomNode(self)
	# Connect player death signal for changing game over scene
	generateMap()
	spawnPlayer()
	player.triggerAI(mapGenerator)
	player.connect("playerDeath",gameOver)
	spawnEnemies(8)
	BackgroundMusicManager.playfightBGM()
	calExitPosition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkPauseGame()
	gameClear()
	
#generate map
func generateMap():
	mapGenerator.getMap()
	#mapGenerator.mockMap()
	#prepare for navigation
	thisNode.bake_navigation_mesh()
	
#change player position to spawn point
func spawnPlayer():
	player.position = mapGenerator.spawnPlayer()
	
# Check if user pause menu
func checkPauseGame():
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		pauseMenu.show()

# Spawn random enemy type with random position
func spawnEnemies(limit:int):
	for index in limit:
		var randomEnemyType
		var randomType = randi() % enemyTypes.size()
		randomEnemyType = enemyTypes[randomType] 

		var rng = mapGenerator.spawnEnemy()
		var randomPosition = Vector3(rng[0] + 0.5,1.5,rng[1] + 0.5)

		var enemyInstance = randomEnemyType.instantiate()
		enemyInstance.name = "Enemy" + str(index)
		enemiesNode.add_child(enemyInstance)
		enemyInstance.position = randomPosition
	
#save position of exit list	
func calExitPosition():
	exitPositionXList.clear()
	exitPositionZList.clear()
	var exitList : Array[int] = mapGenerator.otherExit
	for i in range(exitList.size()):
		var exitPos : Array[int] = mapGenerator.indexToXZ(exitList[i])
		exitPositionXList.append(exitPos[0])
		exitPositionZList.append(exitPos[1])
	
#check if player are on exit	
func checkIfPlayerExit() -> bool:
	for i in range(exitPositionXList.size()):
		if(player.position.x >= exitPositionXList[i] && 
		player.position.x <= exitPositionXList[i] + 1 &&
		player.position.z >= exitPositionZList[i] &&
		player.position.z <= exitPositionZList[i] + 1):
			return true
	return false
	
func gameOver():
	get_tree().change_scene_to_file("res://user_interface/game_over/game_over.tscn")

# Check if enemies are zero / player killed all then game is cleared
func gameClear():
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		if(checkIfPlayerExit()):
			get_tree().change_scene_to_file("res://user_interface/game_clear/game_clear.tscn")
