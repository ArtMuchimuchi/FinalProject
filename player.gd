extends CharacterBody3D

var lastDirection : int = EntityDirection.right
var direction : Vector3 = Vector3.ZERO
var isDash : bool = false

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var animationManager = preload("res://animation_manager.gd").new()
@onready var movement = preload("res://movement_handler.gd").new()

func _physics_process(delta):
	playerMovement()
	playerAnimation(delta)
	
	move_and_slide()


func playerMovement():
	#Check user input movement
	checkPlayerInput()
	#Update last direction of player facing
	lastDirection = animationManager.updateLastDirection(direction.x,lastDirection)
	#Calculate player movement in 4 directional
	velocity = movement.movementHandler(direction, ConstantNumber.playerSpeed)
	#Reset the directional input of playerInput function to zero vector
	resetDirection()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection,animationSprite, delta)

func checkPlayerInput():
	# Check 4 direction movement that player could control
	if Input.is_action_pressed("move_forward"):
		direction.z -= ConstantNumber.directionConstant
	if Input.is_action_pressed("move_back"):
		direction.z += ConstantNumber.directionConstant
	if Input.is_action_pressed("move_left"):
		direction.x -= ConstantNumber.directionConstant
	if Input.is_action_pressed("move_right"):
		direction.x += ConstantNumber.directionConstant
	
	if Input.is_action_just_pressed("dash"):
		isDash = true
		
	# Make Diagonal movement same speed as horizontal and vertical
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
func resetDirection():
	direction = Vector3.ZERO
