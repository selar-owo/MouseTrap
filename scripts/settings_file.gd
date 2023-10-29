extends Node

var save_path := "user://settings.cfg"
var config := ConfigFile.new()
var load_response := config.load(save_path)

func _ready():
	var file = FileAccess.file_exists(save_path)
	print('arseyup')
	if !file:
		save_setting("LogoShake",1)
		save_setting("AutoRemoveBlacklistWords",true)
		save_setting("Blacklist",["y2mate.com - ", ".mp3"])
		save_setting("CountLoopsForTimesPlayed",false)
		var dir_access = DirAccess.open("user://")
		print('arsedependsontheday')

func save_setting(key,value):
	config.set_value("Settings",key,value)
	config.save(save_path)

func load_setting(key):
	return config.get_value("Settings",key)
