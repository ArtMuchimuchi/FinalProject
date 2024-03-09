extends Node

class_name AnimationManager

func movementAnimation(animationPlayer: AnimationPlayer,velocity : Vector3, movementState : int):
	#If character doesn't move, play idle animation
	if velocity.x == ConstantNumber.noMovementConstant && velocity.z == ConstantNumber.noMovementConstant: 
		animationPlayer.play("Idle")
	#If character dash
	elif movementState == EntityState.dash :
		animationPlayer.play("Dash")
	#If character does move, play run animation
	elif velocity.x != ConstantNumber.noMovementConstant || velocity.z != ConstantNumber.noMovementConstant:
		animationPlayer.play("Run")
	
func flipAnimation(lastDirection : int, animatedSprite : AnimatedSprite3D, delta : float):
	var rotation : int
	if lastDirection == EntityDirection.right:
		rotation = EntityRotation.right
	elif lastDirection == EntityDirection.left:
		rotation = EntityRotation.left
	animatedSprite.rotation_degrees.y = lerp(animatedSprite.rotation_degrees.y, float(rotation), delta * ConstantNumber.flipConstant)
	
