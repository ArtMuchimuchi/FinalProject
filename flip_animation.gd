extends Node

func updateLastDirectionHorizontal(velocity:float, lastDirection : int): 
	if velocity > 0: 
		lastDirection = EntityDirection.right
	elif  velocity < 0:
		lastDirection = EntityDirection.left
	return lastDirection
	
func flipAnimation(lastDirection : int, animatedSprite : AnimatedSprite3D, delta : float ):
	var rotation : int
	if lastDirection == EntityDirection.right:
		rotation = EntityRotation.right
	elif lastDirection == EntityDirection.left:
		rotation = EntityRotation.left
	animatedSprite.rotation_degrees.y = lerp(animatedSprite.rotation_degrees.y,float(rotation),delta)
	
