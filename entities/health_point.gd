extends Node

class_name HealthPoint

var ownerNode : Entity
var currentHP : int
	
func _init(targetNode: Entity, setHP: int):
	ownerNode = targetNode
	currentHP = setHP
	
func  increaseHP(increaseAmount: int):
	currentHP += increaseAmount
	
func decreaseHP(decreaseAmount: int):
	if(decreaseAmount >= currentHP):
		die()
	else:
		currentHP -= decreaseAmount
	
func die():
	if(ownerNode.name == "Player"):
		ownerNode.get_tree().paused = true
	else:
		ownerNode.queue_free()
