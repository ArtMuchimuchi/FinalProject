extends Node3D

class_name RayCastGroup

const NORTH : int = 0 
const NORTH_EAST : int = 1 
const EAST : int = 2
const SOUTH_EAST : int = 3 
const SOUTH : int = 4
const SOUTH_WEST : int = 5
const WEST : int = 6
const NORTH_WEST : int = 7

@onready var north : RayCast3D = get_node(str(NORTH))
@onready var northEast : RayCast3D = get_node(str(NORTH_EAST))
@onready var east : RayCast3D = get_node(str(EAST))
@onready var southEast : RayCast3D = get_node(str(SOUTH_EAST))
@onready var south : RayCast3D = get_node(str(SOUTH))
@onready var southWest : RayCast3D = get_node(str(SOUTH_WEST))
@onready var west : RayCast3D = get_node(str(WEST))
@onready var northWest : RayCast3D = get_node(str(NORTH_WEST))

var collideVector : Array[int] = [0,0,0,0,0,0,0,0]
var noCollitionVector : Array[int] = [0,0,0,0,0,0,0,0]
var interestVector : Array[float] = [0,0,0,0,0,0,0,0]
var contextVector : Array[float] = [0,0,0,0,0,0,0,0]
var directionVector : Array[Vector2] = [Vector2(0,-1),
Vector2(1,-1),
Vector2(1,0),
Vector2(1,1),
Vector2(0,1),
Vector2(-1,1),
Vector2(-1,0),
Vector2(-1,-1)]
	
func getCollider():
	if(north.is_colliding()):
		collideVector[NORTH] -= 5
		collideVector[NORTH + 1] -= 2
		collideVector[NORTH_WEST] -= 2
	if(northEast.is_colliding()):
		collideVector[NORTH_EAST] -= 5
		collideVector[NORTH_EAST + 1] -= 2
		collideVector[NORTH_EAST - 1] -= 2
	if(east.is_colliding()):
		collideVector[EAST] -= 5
		collideVector[EAST + 1] -= 2
		collideVector[EAST - 1] -= 2
	if(southEast.is_colliding()):
		collideVector[SOUTH_EAST] -= 5
		collideVector[SOUTH_EAST + 1] -= 2
		collideVector[SOUTH_EAST - 1] -= 2
	if(south.is_colliding()):
		collideVector[SOUTH] -= 5
		collideVector[SOUTH + 1] -= 2
		collideVector[SOUTH - 1] -= 2
	if(southWest.is_colliding()):
		collideVector[SOUTH_WEST] -= 5
		collideVector[SOUTH_WEST + 1] -= 2
		collideVector[SOUTH_WEST - 1] -= 2
	if(west.is_colliding()):
		collideVector[WEST] -= 5
		collideVector[WEST + 1] -= 2
		collideVector[WEST - 1] -= 2
	if(northWest.is_colliding()):
		collideVector[NORTH_WEST] -= 5
		collideVector[NORTH_WEST - 1] -= 2
		collideVector[NORTH] -= 2

func calInterest(direction : Vector2):
	for i in range(interestVector.size()):
		interestVector[i] = direction.dot(directionVector[i])
		
func calContext():
	for i in range(contextVector.size()):
		contextVector[i] = float(interestVector[i] + collideVector[i])
	collideVector = [0,0,0,0,0,0,0,0]
		
func getDirection() -> int:
	var max = 0
	var direction = -1
	for i in range(contextVector.size()):
		if(contextVector[i] > max):
			max = contextVector[i]
			direction = i
	return direction
