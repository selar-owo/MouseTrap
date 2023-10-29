extends Button

@export var id := -1
@export var song_name := "err"
@export var song_length := -1.0
@export var song_path := "null"
@export var icon_image_path := "null"
var true_name:String
var blacklistfree_name:String
var current_duration := "-1"
var selected := false
var is_folder := false
var dc_allowed := false
var blacklist_name:String
var compiled_texture:Resource

@onready var name_label = $Name
@onready var id_label = $Id
@onready var duration_label = $"../../LilLine/Duration"
@onready var main = $"../.."
@onready var icon_node = $Roundifier/Icon
var t := false

func _ready():
	blacklist_name = song_name
	if SettingsFile.load_setting("AutoRemoveBlacklistWords"):
		for i in SettingsFile.load_setting("Blacklist"):
			blacklist_name = blacklist_name.replace(i,"")
	name_label.text = str(blacklist_name)
	
	if is_folder:
		id_label.text = "folder"
		icon_node.set_texture(preload("res://sprites/FolderIcon.png"))
	else:
		duration_label.text = str(song_length," seconds")
		var true_no_mp3 = true_name.replace(".mp3","")
		if song_path != "null" and FileAccess.file_exists(str("user://images/",true_no_mp3,".png")):
			FindSongs.save_cfg(true_name,"image_path",str("user://images/",true_no_mp3,".png"))
		
		if FindSongs.load_cfg(true_name,"image_path") != "null":
			var image = Image.load_from_file(str(FindSongs.load_cfg(true_name,"image_path")))
			var t = ImageTexture.create_from_image(image)
			compiled_texture = t
			icon_node.texture = compiled_texture

func _process(delta):
	if !is_folder:
		id_label.text = str(FindSongs.load_cfg(self.true_name.get_file(),"amount_played"))
	
	if Input.is_action_just_pressed("right_click") and t:
		Globals.hovering["name"] = song_name
		Globals.hovering["true_name"] = true_name
	
	if selected:
		self.self_modulate = Color(0, 1, 0.15686275064945)
	else:
		self.self_modulate = Color(1,1,1)

func _on_button_down():
	if is_folder:
		main.change_playlist(song_name)
	else:
		if main.song_selected == self and dc_allowed:
			main.play_song()
			dc_allowed = false
			return
		main.change_song_selected(self)
		dc_allowed = true
		await get_tree().create_timer(0.2).timeout
		dc_allowed = false

func _on_mouse_entered():
	if !is_folder:
		Globals.right_click_allowed = true
		t = true

func _on_mouse_exited():
	Globals.right_click_allowed = false
	t = false
