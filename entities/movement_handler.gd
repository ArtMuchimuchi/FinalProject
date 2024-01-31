extends Node

class_name MovementHandler

var lastDirection : int 
var direction : Vector3 
var isDash : bool 
var dashCountdown : float
var ownerNode : CharacterBody3D

#initiate varbles
func _init(targetNode : CharacterBody3D):
	lastDirection = EntityDirection.right
	direction = Vector3.ZERO
	isDash = false
	dashCountdown = 0
	ownerNode = targetNode
	
#check player input and change into vector 3d
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
		
	# Make Diagonal movement same speed as horizontal and vertical
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
#calculate direction to the desired direction	
func calculateDirection(desiredPosition : Vector3):
	direction = (desiredPosition - ownerNode.position).normalized()

#change direction into entity velocity
func movementHandler(speed : int):
	# Move when there is direction
	if direction: 
		ownerNode.velocity.x = direction.x * speed 
		ownerNode.velocity.z = direction.z * speed 
	# Slow down the movement when there aren't direction
	else: 
		ownerNode.velocity.x = move_toward(ownerNode.velocity.x, ConstantNumber.noMovementConstant, speed)
		ownerNode.velocity.z = move_toward(ownerNode.velocity.z, ConstantNumber.noMovementConstant, speed)
	#Reset the direction input after moving
	direction = Vector3.ZERO

#check latest movement and save lastest direction where entity was point
func updateLastDirection(): 
	if direction.x > ConstantNumber.noMovementConstant: 
		lastDirection = EntityDirection.right
	elif  direction.x < ConstantNumber.noMovementConstant:
		lastDirection = EntityDirection.left

#dashing for player
func dash(delta: float):
	#Check if dash
	if isDash == true:
		#Dash with direction input
		if direction: 
			ownerNode.velocity.x = direction.x * ConstantNumber.playerDashSpeed
			ownerNode.velocity.z = direction.z * ConstantNumber.playerDashSpeed
		#Dash without direction input depend on last direction
		else:
			if(lastDirection == EntityDirection.right):
				ownerNode.velocity.x = EntityDirection.right * ConstantNumber.playerDashSpeed
			elif (lastDirection == EntityDirection.left):
				ownerNode.velocity.x = EntityDirection.left * ConstantNumber.playerDashSpeed
		if (dashCountdown >= ConstantNumber.playerDashDuration) :
			isDash = false
			dashCountdown = 0
		else :
			dashCountdown += delta
