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

func _process(delta):
	if(north.is_colliding()):
		collideVector[NORTH] = -5
	else :
		collideVector[NORTH] = 0
	if(northEast.is_colliding()):
		collideVector[NORTH_EAST] = -5
	else :
		collideVector[NORTH_EAST] = 0
	if(east.is_colliding()):
		collideVector[EAST] = -5
	else :
		collideVector[EAST] = 0
	if(southEast.is_colliding()):
		collideVector[SOUTH_EAST] = -5
	else :
		collideVector[SOUTH_EAST] = 0
	if(south.is_colliding()):
		collideVector[SOUTH] = -5
	else :
		collideVector[SOUTH] = 0
	if(southWest.is_colliding()):
		collideVector[SOUTH_WEST] = -5
	else :
		collideVector[SOUTH_WEST] = 0
	if(west.is_colliding()):
		collideVector[WEST] = -5
	else :
		collideVector[WEST] = 0
	if(northWest.is_colliding()):
		collideVector[NORTH_WEST] = -5
	else :
		collideVector[NORTH_WEST] = 0
	#print(collideVector)

func calInterest(direction : Vector2):
	for i in range(interestVector.size()):
		interestVector[i] = direction.dot(directionVector[i])
		
func calContext():
	for i in range(contextVector.size()):
		contextVector[i] = float(interestVector[i] + collideVector[i])
		
func getDirection() -> int:
	var max = 0
	var direction = -1
	for i in range(contextVector.size()):
		if(contextVector[i] > max):
			max = contextVector[i]
			direction = i
	return direction
