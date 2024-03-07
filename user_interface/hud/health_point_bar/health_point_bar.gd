extends TextureProgressBar

@onready var currentHealthLabel = $CurrentHealthLabel


func _ready():
	# Set default health point bar of player
	max_value = ConstantNumber.playerHealthPoint 
	value = max_value
	currentHealthLabel.text = "%s / %s" %[value,max_value]

# Update current health point label 
func updateCurrentHealth(currentHP : int ):
	value = currentHP 
	currentHealthLabel.text = "%s / %s" %[currentHP,max_value]
