extends Control



func onEasyModeButtonPressed():
	FloorManager.setDifficultyMode(ConstantNumber.easyMode)
	SceneLoader.loadScene("res://game_controller/game_controller.tscn")

func onNormalModeButtonPressed():
	FloorManager.setDifficultyMode(ConstantNumber.normalMode)
	SceneLoader.loadScene("res://game_controller/game_controller.tscn")

func onHardModeButtonPressed():
	FloorManager.setDifficultyMode(ConstantNumber.hardMode)
	SceneLoader.loadScene("res://game_controller/game_controller.tscn")
