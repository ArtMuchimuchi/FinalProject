extends Node

var floorLevel : int = 1
var transferPlayerData : Dictionary = {}
var difficultyMode : int = ConstantNumber.easyMode

signal changedfloorLevel(changedlevel:int)
# When player move to next floor
func toNextFloorLevel(playerData : Dictionary):
	floorLevel += 1
	transferPlayerData = playerData
	changedfloorLevel.emit(floorLevel)

func resetFloorData():
	floorLevel = 1
	transferPlayerData = {}

func setDifficultyMode(mode:int):
	difficultyMode = mode

func resetDifficultyMode():
	difficultyMode = ConstantNumber.easyMode
