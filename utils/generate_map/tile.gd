class_name Tile

var type : int
var top 
var bottom
var left 
var right 

func _init(inputType: int, index: int, maxIndex: int):
	#assign type for tile
	type = inputType
	#check if top row, if yes, then top = null
	if(index / maxIndex == 0):
		top = null
	#if not, assign top index
	else:
		top = index - maxIndex
	#check if bottom row, if yes, then bot = null
	if((index / maxIndex) >= (maxIndex - 1)):
		bottom = null
	#if not, assign bottom index
	else:
		bottom = index + maxIndex
	#check if lefttest column, if yes, then left = null
	if(index % maxIndex == 0):
		left = null
	#if not, assign left index
	else:
		left = index - 1
	#check if righest column, if yes, then right = null
	if(index % maxIndex == (maxIndex - 1)):
		right = null
	#if not, assign right index
	else:
		right = index + 1
