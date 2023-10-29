extends Node

var default_icon := preload("res://sprites/RatTrapIcon.png")
var BLACKLISTED_WORDS := [
	"y2mate.com - ",
	".mp3",
]
var hovering := {
	"name": null,
	"true_name": null,
}
var version_number := {
	"huge_release": 0,
	"major_release": 3,
	"minor_release": 0,
}

var right_click_allowed := false

var error_message

func seconds2hhmmss(total_seconds: float) -> String:
	#total_seconds = 12345
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var hours:  int   =  int(total_seconds / 3600.0)
	var hhmmss_string:String = "%02d:%02d:%05.2f" % [hours, minutes, seconds]
	return hhmmss_string

func fail_safe(message="NO_MESSAGE_FOUND"):
	error_message = message
	get_tree().change_scene_to_file("res://scenes/FailSafe.tscn")
