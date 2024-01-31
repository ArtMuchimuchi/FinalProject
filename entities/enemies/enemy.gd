extends CharacterBody3D

@onready var player = get_node("../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var movement = MovementHandler.new(self)
@onready var animationManager = AnimationManager.new()
@onready var healthPoint : HealthPoint = HealthPoint.new(10, self)

func _physics_process(delta):
	move()
	animation(delta)
	
func move():
	#calculate direction for chasing player
	movement.calculateDirection(player.global_position)
	#Update last direction of player facing
	movement.updateLastDirection()
	#Calculate player movement in 4 directional
	movement.movementHandler(4)
	#move depen on velocity vector
	move_and_slide()

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(movement.lastDirection,animationSprite, delta)
