extends Node3D

@onready var pauseMenu = %PauseMenu
@onready var enemiesNode = $Enemies
@onready var player = $Player
var generalMonkey = preload("res://entities/enemies/general_monkey/general_monkey.tscn")
var flyMonkey = preload("res://entities/enemies/fly_monkey/fly_monkey.tscn")
#
var enemyTypes  = [
	generalMonkey,
	flyMonkey,
] 
# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect player death signal for changing game over scene
	player.connect("playerDeath",gameOver)
	spawnEnemies(4)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkPauseGame()
	gameClear()

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

		var rng = RandomNumberGenerator.new()
		var randomXAxis = rng.randf_range(-3.00,3.00)
		var randomZAxis = rng.randf_range(-2.00,-5.00)
		var randomPosition = Vector3(randomXAxis,0.5,randomZAxis)

		var enemyInstance = randomEnemyType.instantiate()
		enemiesNode.add_child(enemyInstance)
		enemyInstance.position = randomPosition


func gameOver():
	get_tree().change_scene_to_file("res://user_interface/game_over/game_over.tscn")

# Check if enemies are zero / player killed all then game is cleared
func gameClear():
	if enemiesNode.get_child_count() == 0:
		get_tree().change_scene_to_file("res://user_interface/game_clear/game_clear.tscn")
