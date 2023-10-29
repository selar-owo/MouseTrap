extends Panel

@onready var rename = $RenameMenuButSmaller/Rename
@onready var new_name = $RenameMenuButSmaller/NewName
@onready var right_click_menu = $"../RightClickMenu"
@onready var main = $".."
@onready var cancel = $Cancel
@onready var title = $Title

@onready var rename_menu_but_smaller = $RenameMenuButSmaller
@onready var change_folder = $ChangeFolder

func _ready():
	cancel.pressed.connect(func():
		change_visible(false)
		)
	
	rename.pressed.connect(func():
		FindSongs.save_cfg(Globals.hovering["true_name"],"name",new_name.text)
		change_visible(false)
		main.list_files_in_songs_folder()
		main.load_song_buttons()
		)

func change_visible(is_visible,type="rename"):
	self.visible = is_visible
	rename_menu_but_smaller.visible = (type == "rename")
	change_folder.visible = (type == "change_folder")
	if is_visible:
		if type == "rename":
			title.text = str("rename ",Globals.hovering["name"])
		if type == "change_folder":
			title.text = str("change folder of ",Globals.hovering["name"])
