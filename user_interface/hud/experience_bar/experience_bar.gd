extends HBoxContainer

@onready var experienceLabel = get_node("TextureProgressBar/ExperienceLabel")
@onready var experienceProgressBar = get_node("TextureProgressBar")
@onready var currentLevelLabel = get_node("LevelLabel")

func updateCurrentEXPAndLevel(currentEXP : int, nextLevelEXP : int,currentLevel : int ):
	currentLevelLabel.text = "LV. %s" %currentLevel
	experienceProgressBar.max_value = nextLevelEXP
	experienceProgressBar.value = currentEXP
	experienceLabel.text = "%s / %s" %[currentEXP,nextLevelEXP]
	
