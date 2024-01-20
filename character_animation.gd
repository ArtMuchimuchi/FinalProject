extends Node

func playAnimation(animationPlayer: AnimationPlayer,velocity : Vector3):
	#If character doesn't move, play idle animation
	if velocity.x == ConstantNumber.idleAnimationConstant && velocity.z == ConstantNumber.idleAnimationConstant: 
		animationPlayer.play("Idle")
	#If character does move, play run animation
	elif velocity.x != ConstantNumber.idleAnimationConstant || velocity.z != ConstantNumber.idleAnimationConstant:
		animationPlayer.play("Run")
	return animationPlayer

func updateLastDirection(velocity:float, lastDirection : int): 
	if velocity > ConstantNumber.noMovementConstant: 
		lastDirection = EntityDirection.right
	elif  velocity < ConstantNumber.noMovementConstant:
		lastDirection = EntityDirection.left
	return lastDirection
	
func flipAnimation(lastDirection : int, animatedSprite : AnimatedSprite3D, delta : float ):
	var rotation : int
	if lastDirection == EntityDirection.right:
		rotation = EntityRotation.right
	elif lastDirection == EntityDirection.left:
		rotation = EntityRotation.left
	animatedSprite.rotation_degrees.y = lerp(animatedSprite.rotation_degrees.y,float(rotation),delta)
	
