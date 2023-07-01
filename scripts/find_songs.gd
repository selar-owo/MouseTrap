extends Node

var save_path := "user://songlist.cfg"
var config := ConfigFile.new()
var load_response := config.load(save_path)

func _ready():
	var file = FileAccess.file_exists(save_path)
	print('arsenot')
	if !file:
		config.set_value("Hey!","this is where every song name, id, and file path is located","if you dont know what you are doing, dont touch anything here!")
		config.save(save_path)
		var dir_access = DirAccess.open("user://")
		dir_access.make_dir("songs")
		dir_access.make_dir("images")
		print('arse')

func save_cfg(section,key,value):
	config.set_value(section,key,value)
	config.save(save_path)

func load_cfg(section,key):
	return config.get_value(section,key)
