extends CharacterBody3D

var lastDirection : int = EntityDirection.right
var direction : Vector3 = Vector3.ZERO
var isDash : bool = false
var dashCountdown : float = 0

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var animationManager = preload("res://animation_manager.gd").new()
@onready var movement = preload("res://movement_handler.gd").new()

func _physics_process(delta):
	#Check user input movement
	direction = movement.checkPlayerInput()
	#Update last direction of player facing
	lastDirection = movement.updateLastDirection(direction.x,lastDirection)
	#Check is player dash or not
	if Input.is_action_just_pressed("dash"):
		isDash = true
	#if player dash then do the dash thing, other wise do movement
	if(isDash):
		dash(delta)
	else :
		playerMovement()
		playerAnimation(delta)
	
	move_and_slide()


func playerMovement():
	#Calculate player movement in 4 directional
	velocity = movement.movementHandler(direction, ConstantNumber.playerSpeed)
	#Reset the directional input of playerInput function to zero vector
	resetDirection()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection,animationSprite, delta)
	
func resetDirection():
	direction = Vector3.ZERO

func dash(delta: float):
	if isDash == true:
		# Move when there is direction
		if direction: 
			velocity.x = direction.x * 7 
			velocity.z = direction.z * 7
		else:
			if(lastDirection == EntityDirection.right):
				velocity.x = 1 * 7
			elif (lastDirection == EntityDirection.left):
				velocity.x = -1 * 7
		if (dashCountdown >= 0.08) :
			isDash = false
			dashCountdown = 0
		else :
			dashCountdown += delta
