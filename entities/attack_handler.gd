extends Node

class_name AttackHandler

var ownerNode : Entity
var hitbox : Area3D

#initiate varbles
func _init(targetNode : Entity, targetHitbox: Area3D):
	ownerNode = targetNode
	hitbox = targetHitbox

#entity attacking
func attack():
	#change hit box
	updateHitbox()
	#check enemies in range
	var enemies = hitbox.get_overlapping_bodies()
	#define attack direction for knock back
	var attackDirection = ownerNode.lastDirection
	#damage enemies in attack range
	for enemy in enemies:
		if enemy.has_method("damaged"):
			enemy.damaged(attackDirection, 1)
	
#method for update hitbox
func  updateHitbox():
	hitbox.position.x = ownerNode.lastDirection
