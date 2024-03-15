extends Node

class_name HealthPoint

var ownerNode : Entity
var currentHP : int
var maxHP : int

func _init(targetNode: Entity, setHP: int):
	ownerNode = targetNode
	currentHP = setHP
	maxHP = setHP
	
func  increaseHP(increaseAmount: int):
	currentHP += increaseAmount
	ownerNode.emit_signal("hpChanged",currentHP,maxHP)

func decreaseHP(decreaseAmount: int):
	if(decreaseAmount >= currentHP):
		die()
	else:
		currentHP -= decreaseAmount
		ownerNode.emit_signal("hpChanged",currentHP,maxHP)

func die():
	if(ownerNode.name == "Player"):
		ownerNode.get_tree().paused = true
	else:
		ownerNode.queue_free()

func updateHPFromPercentage(modifiedHP:int, baseHP: int):
	var currentHPRatio  = float(currentHP) / baseHP
	var newCurrentHP : int = modifiedHP * currentHPRatio
	maxHP = modifiedHP
	currentHP = newCurrentHP
	ownerNode.emit_signal("hpChanged",currentHP,maxHP)
	
