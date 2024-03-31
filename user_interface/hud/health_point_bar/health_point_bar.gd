extends TextureProgressBar

@onready var currentHealthLabel = $CurrentHealthLabel


# Update current health point label 
func updateCurrentHealth(currentHP : int, maxHP : int ):
	max_value = maxHP
	value = currentHP
	currentHealthLabel.text = "%s / %s" %[value,max_value]
	
