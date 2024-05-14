extends Node

var floorLevel : int = 1
var transferPlayerData : Dictionary = {}
signal changedfloorLevel(changedlevel:int)
# When player move to next floor
func toNextFloorLevel(playerData : Dictionary):
	floorLevel += 1
	transferPlayerData = playerData
	changedfloorLevel.emit(floorLevel)

func resetFloorData():
	floorLevel = 1
	transferPlayerData = {}
