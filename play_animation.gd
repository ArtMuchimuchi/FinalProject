extends Node

func selectAnimation(animationPlayer: AnimationPlayer,velocity : Vector3):
	#If character doesn't move, play idle animation
	if velocity.x == ConstantNumber.idleAnimationConstant && velocity.z == ConstantNumber.idleAnimationConstant: 
		animationPlayer.play("Idle")
	#If character does move, play run animation
	elif velocity.x != ConstantNumber.idleAnimationConstant || velocity.z != ConstantNumber.idleAnimationConstant:
		animationPlayer.play("Run")
	return animationPlayer
