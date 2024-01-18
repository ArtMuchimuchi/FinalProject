extends Node

class_name  PlayerInput
var direction = Vector3.ZERO
var dash : bool = false
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
	
	if Input.is_action_just_pressed("dash"):
		dash = true
	# Make Diagonal movement same speed as horizontal and vertical
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
#Reset the direction or it will use previous input when called checkPlayerInput
func resetDirection():
	direction = Vector3.ZERO
