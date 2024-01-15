extends CharacterBody3D

const speed = 5
var lastDirection = "Right"
var dash = false
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var flipAnimation = preload("res://flipAnimation.gd").new()



func _physics_process(delta):
	var direction = Vector3.ZERO
	direction = checkPlayerInput(direction)
	velocity = calculateVeclocity(direction)
	lastDirection = flipAnimation.checkLastDirectionHorizontal(velocity.x,lastDirection)
	playAnimation(animationPlayer,velocity)
	flipAnimation.flipAnimation(lastDirection,animationSprite, delta * 10)
	move_and_slide()

func checkPlayerInput(direction : Vector3):
	# Check 4 direction movement that player could control
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if Input.is_action_just_pressed("dash"):
		dash = true
	# Make Diagonal movement same speed as horizontal and vertical
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	return direction
	

func calculateVeclocity(direction : Vector3):
	# If press direction key player will move with speed 
	if direction: 

		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed 
	# If not press anything, speed will decress to 0 / decelerate
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	return velocity

func playAnimation(animationPlayer: AnimationPlayer,velocity : Vector3):
	if velocity.x == 0 && velocity.z == 0: 
		animationPlayer.play("Idle")
	elif velocity.x != 0 || velocity.z != 0:
		animationPlayer.play("Run")
	return animationPlayer
