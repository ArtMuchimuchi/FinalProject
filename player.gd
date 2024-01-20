extends CharacterBody3D

var lastDirection : int = EntityDirection.right
var direction : Vector3 = Vector3.ZERO
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var characterAnimation = preload("res://character_animation.gd").new()
@onready var movement = preload("res://movement_handler.gd").new()
@onready var playerInput = preload("res://player_input.gd").new()
func _physics_process(delta):
	playerMovement()
	playerAnimation(delta)
	move_and_slide()


func playerMovement():
	#Check user input movement
	playerInput.checkPlayerInput()
	#Assign directional input 
	direction = playerInput.direction
	#Update last direction of player facing
	lastDirection = characterAnimation.updateLastDirection(direction.x,lastDirection)
	#Calculate player movement in 4 directional
	velocity = movement.movementHandler(direction,ConstantNumber.playerSpeed, playerInput.dash)
	#Reset the directional input of playerInput function to zero vector
	playerInput.resetDirection()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	characterAnimation.playAnimation(animationPlayer,velocity)
	#Flip direction of player 
	characterAnimation.flipAnimation(lastDirection,animationSprite, delta * ConstantNumber.flipConstant)

