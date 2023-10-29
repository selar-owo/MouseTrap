extends Control

@onready var rename_menu = $"../RenameMenu"

@onready var rename = $Rename
@onready var change_icon = $ChangeIcon
@onready var change_playlist = $ChangePlaylist

@onready var area_of_funny = $AreaOfFunny
@onready var change_icon_dialog = $"../ChangeIconDialog"
@onready var main = $".."
var can_click2rem := false

func _ready():
	rename.connect("pressed",func():
		rename_menu.change_visible(true)
		visible = false
		)
	
	change_icon.connect("pressed",func():
		change_icon_dialog.popup_centered()
		visible = false
		)
	change_icon_dialog.connect("file_selected",func(path:String):
		if path.ends_with(".png"):
			FindSongs.save_cfg(Globals.hovering["true_name"],"image_path",path)
			main.list_files_in_songs_folder()
			main.load_song_buttons()
		)
	
	change_playlist.connect("pressed",func():
		rename_menu.change_visible(true,"change_folder")
		visible = false
		)
	
	area_of_funny.connect("mouse_entered",func():
		can_click2rem = false
		)
	area_of_funny.connect("mouse_exited",func():
		can_click2rem = true
		)

func _process(delta):
	if Input.is_action_just_pressed("right_click") and Globals.right_click_allowed:
		visible = !visible
		self.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click") and can_click2rem:
		hide()

func _on_area_of_funny_mouse_entered():
	can_click2rem = false

func _on_area_of_funny_mouse_exited():
	can_click2rem = true
