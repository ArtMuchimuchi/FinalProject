extends CharacterBody3D

class_name Entity

var meleeAttackDamage : int
var rangeAttackDamage : int
var healthPoint : int
var movementSpeed : int
var movementState : int
var dashSpeed : int
var lastDirection : int 
var direction : Vector3 
var movementCountdown : float

#initiate varables for entity
func initEntity():
	lastDirection = EntityDirection.left
	direction = Vector3.ZERO
	movementState = EntityState.idle
	movementCountdown = 0

#method for damaging this entity
func damaged(direction: int, damage: int):
	assert(false)