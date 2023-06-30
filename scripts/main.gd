extends Control

@onready var songs = $Songs
@onready var v_scroll_bar = $VScrollBar
@onready var cur_song_playing = $CurSongPlaying
@onready var song_audio = $SongAudio
@onready var duration_label = $LilLine/Duration
var prev_scroll_value

var all_songs:Array
var song_selected

func _ready():
	prev_scroll_value = v_scroll_bar.value
	list_files_in_songs_folder()
	load_song_buttons()

func _process(delta):
	if song_selected != null:
		duration_label.text = str(round(song_audio.get_playback_position()))
		AudioStreamPlayer

func change_song_selected(song):
	if song != null:
		song_selected = song
		cur_song_playing.text = song.song_name.replace(".mp3","")
		var file := FileAccess.open(song.song_path,FileAccess.READ)
		var data = file.get_buffer(file.get_length())
		var stream := AudioStreamMP3.new()
		stream.data = data
		song_audio.set_stream(stream)

func load_song_buttons():
	for i in songs.get_children():
		i.queue_free()
	
	var pos_y = 5
	for i in all_songs:
		var button := preload("res://scenes/song.tscn").instantiate()
		button.song_name = FindSongs.load_cfg(i,"name")
		button.id = FindSongs.load_cfg(i,"id")
		button.song_length = FindSongs.load_cfg(i,"length")
		button.song_path = FindSongs.load_cfg(i,"path")
		songs.add_child(button)
		button.position = Vector2(5,pos_y)
		pos_y += 75
		print(i)

func list_files_in_songs_folder():
	var files = []
	var dir = DirAccess.open("user://songs")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".mp3"):
			files.append(file)
			if FindSongs.load_cfg(file.get_file(),"id") == null:
				FindSongs.save_cfg(file.get_file(),"id",randi_range(0,999999999999))
				FindSongs.save_cfg(file.get_file(),"name",file)
				FindSongs.save_cfg(file.get_file(),"length",-1.0)
				FindSongs.save_cfg(file.get_file(),"path",str("user://songs/",file.get_file()))
	
	dir.list_dir_end()
	
	all_songs = files
	print(all_songs)

func _on_v_scroll_bar_value_changed(value):
	songs.position.y += prev_scroll_value - value
	prev_scroll_value = value

func _on_play_button_up():
	song_audio.play()
