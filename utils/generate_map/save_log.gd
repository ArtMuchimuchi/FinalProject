class_name SaveLog

var data : Dictionary

const SAVE_PATH = "res://log1.json"

func add(key, value):
	data[key] = value

func display():
	print(data)
	
func save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
