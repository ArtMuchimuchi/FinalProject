extends Node

func checkPlayerInput():
	var direction : Vector3
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
	
	return direction
	
func calculateDirection(playerPosition : Vector3, currentPosition : Vector3):
	return (playerPosition - currentPosition).normalized()

func movementHandler(direction : Vector3, speed : int):
	var velocity : Vector3 = Vector3.ZERO
	# Move when there is direction
	if direction: 
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed 
	# Slow down the movement when there aren't direction
	else: 
		velocity.x = move_toward(velocity.x, ConstantNumber.noMovementConstant, speed)
		velocity.z = move_toward(velocity.z, ConstantNumber.noMovementConstant, speed)
	
	return velocity
	
func updateLastDirection(velocity:float, lastDirection : int): 
	if velocity > ConstantNumber.noMovementConstant: 
		lastDirection = EntityDirection.right
	elif  velocity < ConstantNumber.noMovementConstant:
		lastDirection = EntityDirection.left
	return lastDirection


