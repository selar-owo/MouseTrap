extends Control

@onready var go_back_button: Button = $Button
@onready var error_message: Label = $ErrorMessage

func _ready() -> void:
	error_message.text = str(error_message.text + Globals.error_message)
	
	go_back_button.connect("button_up",func():
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		)
