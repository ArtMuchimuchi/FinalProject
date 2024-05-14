extends Node

var floorLevel : int = 1
var transferPlayerData : Dictionary = {}

# When player move to next floor
func toNextFloorLevel(playerData : Dictionary):
	floorLevel += 1
	transferPlayerData = playerData
