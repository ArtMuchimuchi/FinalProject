extends CharacterBody3D

var lastDirection : int = EntityDirection.right
var direction : Vector3 = Vector3.ZERO

@onready var player = get_node("../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var movement = preload("res://movement_handler.gd").new()
@onready var animationManager = preload("res://animation_manager.gd").new()

func _physics_process(delta):
	move()
	animation(delta)
	
func move():
	#calculate direction for chasing player
	direction = movement.calculateDirection(player.global_position, self.position)
	#Update last direction of player facing
	lastDirection = movement.updateLastDirection(direction.x,lastDirection)
	#Calculate player movement in 4 directional
	velocity = movement.movementHandler(direction, 4)
	#Reset the directional input of playerInput function to zero vector
	direction = Vector3.ZERO
	#move depen on velocity vector
	move_and_slide()

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection,animationSprite, delta)
