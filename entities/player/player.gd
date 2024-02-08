extends Entity

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var animationManager = AnimationManager.new()
@onready var movement = MovementHandler.new(self)
var HP : HealthPoint

func _init():
	healthPoint = 10
	movementSpeed = ConstantNumber.playerSpeed
	dashSpeed = ConstantNumber.playerDashSpeed
	lastDirection = EntityDirection.right
	direction = Vector3.ZERO
	isDash = false
	dashCountdown = 0
	HP = HealthPoint.new(self)

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
		isDash = true
	#if player dash then do the dash thing, other wise do movement
	if(isDash):
		movement.dash(delta)
	else :
		#Calculate player movement in 4 directional
		movement.movementHandler()
	#move depen on velocity vector
	move_and_slide()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)


