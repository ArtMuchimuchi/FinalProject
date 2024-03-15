extends TextureProgressBar

@onready var currentHealthLabel = $CurrentHealthLabel


func _ready():
	# Set default health point bar of player
	updateCurrentHealth(ConstantNumber.playerHealthPoint,ConstantNumber.playerHealthPoint)

# Update current health point label 
func updateCurrentHealth(currentHP : int, maxHP : int ):
	value = currentHP 
	max_value = maxHP
	currentHealthLabel.text = "%s / %s" %[currentHP,maxHP]
