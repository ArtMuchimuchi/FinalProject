extends TextureProgressBar

@onready var currentHealthLabel = $CurrentHealthLabel


# Update current health point label 
func updateCurrentHealth(currentHP : int, maxHP : int ):
	value = currentHP 
	max_value = maxHP
	currentHealthLabel.text = "%s / %s" %[currentHP,maxHP]
