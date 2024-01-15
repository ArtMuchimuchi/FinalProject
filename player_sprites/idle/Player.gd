extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var lastDirection = "Right"


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if(velocity.y < 0):
			animationSprite.play("Fall")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animationSprite.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	flipAnimation(lastDirection, delta)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocityToLastDirection(velocity.x)
		if(velocity.x != 0 or velocity.z != 0) and (velocity.y == 0):
			animationSprite.play("Run")
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if velocity.y == 0:
			animationSprite.play("Idle")

	move_and_slide()
	
func velocityToLastDirection(velocity: float):
	if(velocity > 0):
		lastDirection = "Right"
	elif(velocity < 0):
		lastDirection = "Left"
	else:
		lastDirection = lastDirection
	
func flipAnimation(lastDirection: String, delta: float):
	var desiredDirection
	if(lastDirection == "Right"):
		desiredDirection = 0
	elif(lastDirection == "Left"):
		desiredDirection = -180
	animationSprite.rotation_degrees[1] = lerp(animationSprite.rotation_degrees[1], float(desiredDirection), delta*10)

