extends Button

@export var id := -1
@export var song_name := "err"
@export var song_length := -1.0
@export var song_path := "null"
@export var icon_image_path := "null"
var true_name:String
var current_duration := "-1"
var selected := false

@onready var name_label = $Name
@onready var id_label = $Id
@onready var duration_label = $"../../LilLine/Duration"
@onready var main = $"../.."
@onready var icon_node = $Roundifier/Icon

func _ready():
	name_label.text = str(song_name)
	duration_label.text = str(song_length," seconds")
	var true_no_mp3 = true_name.replace(".mp3","")
	if song_path != "null" and FileAccess.file_exists(str("user://images/",true_no_mp3,".png")):
		var image = Image.load_from_file(str("user://images/",true_no_mp3,".png"))
		var t = ImageTexture.create_from_image(image)
		icon_node.texture = t

func _process(delta):
	id_label.text = str(FindSongs.load_cfg(self.true_name.get_file(),"amount_played"))
	if selected:
		self.self_modulate = Color(0, 1, 0.15686275064945)
	else:
		self.self_modulate = Color(1,1,1)

func _on_button_down():
	main.change_song_selected(self)
