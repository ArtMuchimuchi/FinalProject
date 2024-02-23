extends Node

class_name AttackHandler

var ownerNode : Entity
var hitbox : Area3D

#initiate varbles
func _init(targetNode : Entity, targetHitbox: Area3D):
	ownerNode = targetNode
	hitbox = targetHitbox

#entity melee attacking
func meleeAttack(damage: int):
	#change hit box
	updateHitbox()
	#check enemies in range
	var enemies = hitbox.get_overlapping_bodies()
	#define attack direction for knock back
	var attackDirection = ownerNode.lastDirection
	#damage enemies in attack range
	for enemy in enemies:
		if enemy.has_method("damaged"):
			#prepare knock back direction
			var knockbackDirection = (enemy.position - ownerNode.position).normalized()
			#garuntee that enemie will knock back in the same direction of attacker
			knockbackDirection.x = attackDirection
			enemy.damaged(knockbackDirection, damage, ConstantNumber.enemyMeleeKnockbackSpeed,
			ConstantNumber.enemyMeleeKnockbackDuration)
			
#entity aoe attacking
func aoeAttack(damage: int):
	#check enemies in range
	var enemies = hitbox.get_overlapping_bodies()
	#damage enemies in attack range
	for enemy in enemies:
		if enemy.has_method("damaged"):
			#prepare knock back direction
			var knockbackDirection = (enemy.position - ownerNode.position).normalized()
			enemy.damaged(knockbackDirection, damage, ConstantNumber.enemyRangeKnockbackSpeed,
			ConstantNumber.enemyRangeKnockbackDuration)
	
#method for update hitbox
func  updateHitbox():
	if(ownerNode.lastDirection == EntityDirection.right):
		hitbox.rotation_degrees.y = EntityRotation.right
	elif(ownerNode.lastDirection == EntityDirection.left):
		hitbox.rotation_degrees.y = EntityRotation.left
