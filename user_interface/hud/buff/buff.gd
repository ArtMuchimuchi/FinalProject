extends PanelContainer

@onready var buffIcon = $PanelContainer/BuffIcon
@onready var buffLevelLabel = $BuffLevelLabel
@onready var mockupBuffIcon = preload("res://icon.svg")



func setBuffData(buffData : BuffData):
		buffIcon.texture = buffData.buffTexture
		buffLevelLabel.text = str(buffData.currentLevel)
		var buffDescription = buffData.getBuffPropertyValue(DictionaryKey.description)
		self.tooltip_text = str(buffData.buffName + "\n" + buffDescription)
