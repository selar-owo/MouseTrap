extends Panel

@onready var new_folder = $NewFolder
@onready var folders = $Folders
@onready var check_box = $CheckBox
@onready var main = $"../.."
@onready var change_folder = $ChangeFolder
@onready var rename_menu = $".."

func _ready():
	check_box.connect("toggled",func(toggle):
		new_folder.visible = toggle
		folders.visible = !toggle
		)
	change_folder.connect("button_down",func():
		if !check_box.button_pressed:
			FindSongs.save_cfg(Globals.hovering["true_name"],"playlist",folders.get_item_text(folders.selected))
		else:
			FindSongs.save_cfg(Globals.hovering["true_name"],"playlist",new_folder.text)
		rename_menu.change_visible(false)
		)
	await get_tree().create_timer(0.5).timeout
	update_playlist()

func update_playlist():
	for i in main.all_playlists:
		folders.add_item(i)


