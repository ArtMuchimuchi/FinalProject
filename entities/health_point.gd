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
		ownerNode.emit_signal("hpChanged",0,maxHP)
		die()
	else:
		# Reduce damage recieved with defense value
		var defense = ownerNode.defense
		if defense < decreaseAmount:
			currentHP -= decreaseAmount - defense 
		# If defense value is greater than damage, reduce damage to 1 
		elif defense >= decreaseAmount:
			currentHP -= ConstantNumber.minimalDamage
		ownerNode.emit_signal("hpChanged",currentHP,maxHP)

func die():
	if(ownerNode.name == "Player"):
		ownerNode.emit_signal("playerDeath")
	else:
		ownerNode.queue_free()

func updateHPFromPercentage(modifiedHP:int, baseHP: int):
	var currentHPRatio  = float(currentHP) / baseHP
	var newCurrentHP : int = modifiedHP * currentHPRatio
	maxHP = modifiedHP
	currentHP = newCurrentHP
	ownerNode.emit_signal("hpChanged",currentHP,maxHP)
	
