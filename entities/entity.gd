extends CharacterBody3D

class_name Entity

var meleeAttackDamage : int
var rangeAttackDamage : int
var healthPoint : HealthPoint
var movementSpeed : int
var movementState : int
var dashSpeed : int
var dashDuration : float
var lastDirection : int 
var direction : Vector3 
var movementCountdown : float
var triedCountdown : float

#initiate varables for entity
func initEntity():
	lastDirection = EntityDirection.left
	direction = Vector3.ZERO
	movementState = EntityState.idle
	movementCountdown = 0
	triedCountdown = 0
	dashDuration = 0
