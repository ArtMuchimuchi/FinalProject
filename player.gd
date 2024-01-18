extends CharacterBody3D

const speed : int  = 3
var lastDirection : int = EntityDirection.right
var dash = false
var direction = Vector3.ZERO
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var flipAnimation = preload("res://flip_animation.gd").new()
@onready var movement = preload("res://movement_handler.gd").new()
@onready var playerInput = preload("res://player_input.gd").new()
@onready var playAnimation = preload("res://play_animation.gd").new()

func _physics_process(delta):
	playerMovement()
	playerAnimation(delta)
	move_and_slide()


func playerMovement():
	#Check user input movement
	playerInput.checkPlayerInput()
	#Assign directional input 
	direction = playerInput.direction
	#Update last direction facing by the directional input
	lastDirection = flipAnimation.updateLastDirectionHorizontal(direction.x,lastDirection)
	#Calculate player movement in 4 directional
	velocity = movement.movementHandler(direction,speed)
	#Reset the directional input of playerInput function to zero vector
	playerInput.resetDirection()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	playAnimation.selectAnimation(animationPlayer,velocity)
	#Flip direction of player 
	flipAnimation.flipAnimation(lastDirection,animationSprite, delta * ConstantNumber.flipConstant)

