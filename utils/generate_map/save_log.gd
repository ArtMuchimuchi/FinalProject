class_name SaveLog

var name : String
var data : Dictionary

var savePath : String 

func  _init(newName : String):
	name = newName
	savePath = "res://utils/generate_map/log/" + name + ".json"

func add(key, value):
	data[key] = value

func display():
	print(data)
	
func save():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
