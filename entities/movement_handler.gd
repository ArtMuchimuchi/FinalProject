extends Node

class_name MovementHandler

var ownerNode : Entity

#initiate varbles
func _init(targetNode : Entity):
	ownerNode = targetNode
	
#check player input and change into vector 3d
func checkPlayerInput():
	# Check 4 direction movement that player could control
	if Input.is_action_pressed("move_forward"):
		ownerNode.direction.z -= ConstantNumber.directionConstant
	if Input.is_action_pressed("move_back"):
		ownerNode.direction.z += ConstantNumber.directionConstant
	if Input.is_action_pressed("move_left"):
		ownerNode.direction.x -= ConstantNumber.directionConstant
	if Input.is_action_pressed("move_right"):
		ownerNode.direction.x += ConstantNumber.directionConstant
		
	# Make Diagonal movement same speed as horizontal and vertical
	if ownerNode.direction != Vector3.ZERO:
		ownerNode.direction = ownerNode.direction.normalized()
	
#calculate direction to the desired direction	
func calculateDirection(desiredPosition : Vector3):
	ownerNode.direction = (desiredPosition - ownerNode.position).normalized()

#change direction into entity velocity
func movementHandler():
	# Move when there is direction
	if ownerNode.direction: 
		ownerNode.velocity.x = ownerNode.direction.x * ownerNode.movementSpeed 
		ownerNode.velocity.z = ownerNode.direction.z * ownerNode.movementSpeed 
	# Slow down the movement when there aren't direction
	else: 
		ownerNode.velocity.x = move_toward(ownerNode.velocity.x, ConstantNumber.noMovementConstant,
		 ownerNode.movementSpeed)
		ownerNode.velocity.z = move_toward(ownerNode.velocity.z, ConstantNumber.noMovementConstant,
		 ownerNode.movementSpeed)
	#Reset the direction input after moving
	ownerNode.direction = Vector3.ZERO

#check latest movement and save lastest direction where entity was point
func updateLastDirection(): 
	if ownerNode.direction.x > ConstantNumber.noMovementConstant: 
		ownerNode.lastDirection = EntityDirection.right
	elif  ownerNode.direction.x < ConstantNumber.noMovementConstant:
		ownerNode.lastDirection = EntityDirection.left

#dashing for player
func dash(delta: float):
	#Check if dash
	if ownerNode.isDash == true:
		#Dash with direction input
		if ownerNode.direction: 
			ownerNode.velocity.x = ownerNode.direction.x * ownerNode.dashSpeed
			ownerNode.velocity.z = ownerNode.direction.z * ownerNode.dashSpeed
		#Dash without direction input depend on last direction
		else:
			if(ownerNode.lastDirection == EntityDirection.right):
				ownerNode.velocity.x = EntityDirection.right * ownerNode.dashSpeed
			elif (ownerNode.lastDirection == EntityDirection.left):
				ownerNode.velocity.x = EntityDirection.left * ownerNode.dashSpeed
		if (ownerNode.dashCountdown >= ConstantNumber.playerDashDuration) :
			ownerNode.isDash = false
			ownerNode.dashCountdown = 0
		else :
			ownerNode.dashCountdown += delta
