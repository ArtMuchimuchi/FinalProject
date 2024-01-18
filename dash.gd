extends Node3D
class_name Dash

@onready var durationTimer = $DurationTimer
#Player can press dash if it's not cooldown
@onready var canDash : bool = true
#How long to player wait to press dash again
var dashCooldown : float = 0.4

#Function when player press dash 
func startDash(duration: float):
	#Set duration of dashing
	durationTimer.wait_time = duration
	durationTimer.start()
	
#Check if player is still dashing or not
func isDashing():
	return !durationTimer.is_stopped()

#Function when player finished dashing
func endDash():
	#Dashing is under cooldown so player can't press dash again 
	canDash = false
	var dashCooldownTimer = get_tree().create_timer(dashCooldown)
	#Wait for cooldown to finished so player can press dash again 
	await dashCooldownTimer.timeout
	canDash = true

#When dashing duration is finished
func _on_duration_timer_timeout():
	endDash()
