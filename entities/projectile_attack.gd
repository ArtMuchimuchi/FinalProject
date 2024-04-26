extends CharacterBody3D

var direction : Vector3 
var damage : int
@onready var animatedSprite : AnimatedSprite3D = get_node("AnimatedSprite3D")

func _ready():
	animatedSprite.play("banana")

func _physics_process(delta):
	var collisionObject = moving(direction, 1, delta)
	#if colli with something then
	if(collisionObject):
		#if collide with player
		if(collisionObject.get_collider().name=="Player"):
			var player = collisionObject.get_collider()
			#deal damage
			if(player.has_method("damaged")):
				player.damaged(Vector3.ZERO, damage, 0, 0)
				queue_free()
		#if collide with map
		elif(collisionObject.get_collider().name=="GridMap"):
			queue_free()
	
#move and check for collision
func moving(direction: Vector3, speed: int, delta: float) -> KinematicCollision3D:
	velocity.x = direction.x * speed 
	velocity.z = direction.z * speed 
	return move_and_collide(velocity * delta)
