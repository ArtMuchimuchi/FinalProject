extends Entity

@onready var player = get_node("../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var movement = MovementHandler.new(self)
@onready var animationManager = AnimationManager.new()
var HP : HealthPoint

func _init():
	healthPoint = 10
	movementSpeed = 4
	dashSpeed = 1
	lastDirection = EntityDirection.right
	direction = Vector3.ZERO
	isDash = false
	dashCountdown = 0
	HP = HealthPoint.new(self)

func _physics_process(delta):
	move()
	animation(delta)
	
func move():
	#calculate direction for chasing player
	movement.calculateDirection(player.global_position)
	#Update last direction of player facing
	movement.updateLastDirection()
	#Calculate player movement in 4 directional
	movement.movementHandler()
	#move depen on velocity vector
	move_and_slide()

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer, velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
