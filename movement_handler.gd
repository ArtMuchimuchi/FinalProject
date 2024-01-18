extends Node

func movementHandler(direction : Vector3, speed : int):
	var velocity : Vector3 = Vector3.ZERO
	# Move when there is direction
	if direction: 
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed 
	# Slow down the movement when there aren't direction
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	return velocity


