extends Node

func checkLastDirectionHorizontal(velocity:float,lastDirection):
	if velocity > 0: 
		lastDirection = "Right"
	elif  velocity < 0:
		lastDirection = "Left"
	return lastDirection
	
func flipAnimation(lastDirection, animatedSprite : AnimatedSprite3D, delta : float ):
	var rotation 
	if lastDirection == "Right":
		rotation = 0
	elif lastDirection == "Left":
		rotation = 180
	animatedSprite.rotation_degrees.y = lerp(animatedSprite.rotation_degrees.y,float(rotation),delta)
	
