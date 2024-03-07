extends PanelContainer

@onready var buffIcon = $PanelContainer/BuffIcon
@onready var buffLevelLabel = $BuffLevelLabel
@onready var mockupBuffIcon = preload("res://icon.svg")
# Called when the node enters the scene tree for the first time.



func setBuffData(buffData : BuffData):
		buffIcon.texture = buffData.texture
		buffLevelLabel.text = str(buffData.currentLevel)
		var currentBuffLevel = buffData.buffLevel[buffData.currentLevel - ConstantNumber.currentBuffLevelIndexDifferent]
		self.tooltip_text = str(buffData.name + "\n" + currentBuffLevel.description)
