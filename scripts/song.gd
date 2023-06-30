extends Button

@export var id := -1
@export var song_name := "err"
@export var song_length := -1.0
@export var song_path := "null"
var current_duration := "-1"

@onready var name_label = $Name
@onready var id_label = $Id
@onready var duration_label = $"../../LilLine/Duration"
@onready var main = $"../.."

func _ready():
	name_label.text = str(song_name)
	id_label.text = str(id)
	duration_label.text = str(song_length," seconds")

func _on_button_down():
	main.change_song_selected(self)
