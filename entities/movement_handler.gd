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
	
#set direction to the desired direction	
func getDirection(desiredPosition : Vector3):
	ownerNode.direction = calculateDirection(ownerNode.position, desiredPosition) 	
	
#calculate direction from 2 positions	
func calculateDirection(startPosition: Vector3, desiredPosition: Vector3) -> Vector3:
	return (desiredPosition - startPosition).normalized()

#reset varables flag so entity can be move normally
func resumeMove():
	ownerNode.canMove = true
	ownerNode.isDash = false
	ownerNode.isKnockback = false
	
#set flag varables for knockback state
func  knockBack(direction: int):
	ownerNode.canMove = false
	ownerNode.isDash = false
	ownerNode.isKnockback = true
	ownerNode.direction.x = direction

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
	#move
	ownerNode.move_and_slide()

#check latest movement and save lastest direction where entity was point
func updateLastDirection(): 
	if ownerNode.direction.x > ConstantNumber.noMovementConstant: 
		ownerNode.lastDirection = EntityDirection.right
	elif  ownerNode.direction.x < ConstantNumber.noMovementConstant:
		ownerNode.lastDirection = EntityDirection.left

#dashing for player
func moveImediately(delta: float, moveSpeed: int, duration: float):
	#Dash with direction input
	if ownerNode.direction: 
		ownerNode.velocity.x = ownerNode.direction.x * moveSpeed
		ownerNode.velocity.z = ownerNode.direction.z * moveSpeed
	#Dash without direction input depend on last direction
	else:
		if(ownerNode.lastDirection == EntityDirection.right):
			ownerNode.velocity.x = EntityDirection.right * moveSpeed
		elif (ownerNode.lastDirection == EntityDirection.left):
			ownerNode.velocity.x = EntityDirection.left * moveSpeed
	if (ownerNode.movementCountdown >= duration) :
		resumeMove()
		ownerNode.movementCountdown = 0
	else :
		ownerNode.movementCountdown += delta
	#move
	ownerNode.move_and_slide()

#move pattern for enemy
func enemyMovement(delta: float, player: Entity):
	#move normally
	if(ownerNode.canMove == true):
		#calculate direction for chasing player
		getDirection(player.position)
		#Update last direction of player facing
		updateLastDirection()
		#check for move pattern
		#Calculate player movement in 4 directional
		movementHandler()
		#get knockback
	elif (ownerNode.isKnockback == true):
		#calculate knock back direction
		moveImediately(delta,14,0.3)
