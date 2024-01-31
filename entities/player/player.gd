extends CharacterBody3D

var healthPoint : int = 10

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var animationManager = AnimationManager.new()
@onready var movement = MovementHandler.new(self)
@onready var HP : HealthPoint = HealthPoint.new(healthPoint, self)

func _physics_process(delta):
	move(delta)
	playerAnimation(delta)

func move(delta : float):
	#Check user input movement
	movement.checkPlayerInput()
	#Update last direction of player facing
	movement.updateLastDirection()
	#Check is player dash or not
	if Input.is_action_just_pressed("dash"):
		movement.isDash = true
	#if player dash then do the dash thing, other wise do movement
	if(movement.isDash):
		movement.dash(delta)
	else :
		#Calculate player movement in 4 directional
		movement.movementHandler(ConstantNumber.playerSpeed)
	#move depen on velocity vector
	move_and_slide()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(movement.lastDirection,animationSprite, delta)


