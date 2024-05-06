extends HBoxContainer


@onready var currentCoinLabel = get_node("CurrentCoinLabel")

func updateCurrentCoin():
	currentCoinLabel.text = str(RewardManager.currentCoin) 
