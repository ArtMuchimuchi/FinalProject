extends CharacterBody3D

class_name Entity

var healthPoint : int
var movementSpeed : int
var dashSpeed : int
var lastDirection : int 
var direction : Vector3 
var isDash : bool 
var canMove : bool
var isKnockback : bool
var movementCountdown : float

#initiate varables for entity
func initEntity():
	lastDirection = EntityDirection.left
	direction = Vector3.ZERO
	isDash = false
	canMove = true
	isKnockback = false
	movementCountdown = 0

#method for damaging this entity
func damaged(direction: int, damage: int):
	assert(false)
