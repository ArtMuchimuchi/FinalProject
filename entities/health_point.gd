extends Node

class_name HealthPoint

var ownerNode : Entity
var displayHP : Label3D
var healthPointLabel : String
	
func _init(targetNode: Entity):
	ownerNode = targetNode
	createDisplayHP()

func updateHP(newHealthPoint: int):
	ownerNode.healthPoint = newHealthPoint
	updateHPDisplay()

func updateHPDisplay():
	#re-create string for display HP
	var labelHP : String = "HP : "
	for i in range (ownerNode.healthPoint):
		labelHP = labelHP + "[]"
	healthPointLabel = labelHP
	#re-display current HP
	displayHP.text = healthPointLabel
	
func createDisplayHP():
	#innitiate string for label HP depends on HP number
	var labelHP : String = "HP : "
	for i in range (ownerNode.healthPoint):
		labelHP = labelHP + "[]"
	healthPointLabel = labelHP
	#create Label node for display HP
	var tempHP : Label3D = Label3D.new()
	#set configuration for label node
	tempHP.set_name("LabelHealthPoint")
	tempHP.text = healthPointLabel
	tempHP.position.y = 0.76
	#add label node to target node
	self.ownerNode.add_child(tempHP)
	#find label node and bound it to this class
	for i in ownerNode.get_children():
		if(i.name.match("LabelHealthPoint")):
			displayHP = i
