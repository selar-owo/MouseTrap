extends Control

@onready var songs = $Songs
@onready var v_scroll_bar = $VScrollBar
@onready var cur_song_playing = $CurSongPlaying
@onready var song_audio = $SongAudio
@onready var duration_label = $LilLine/Duration
@onready var volume = $LilLine/Volume
@onready var loop = $LilLine/Loop
@onready var play = $LilLine/Play
@onready var stop = $LilLine/Stop
@onready var progress = $LilLine/Progress
@onready var logo = $Logo
var prev_scroll_value
var all_songs:Array
var song_selected
var last_song_pos := 0.0
var song_played := false

func _ready():
	prev_scroll_value = v_scroll_bar.value
	logo.pivot_offset = logo.size / 2
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Songs"), volume.value)
	list_files_in_songs_folder()
	load_song_buttons()

func _process(delta):
	if song_selected != null:
		if song_audio.playing:
			duration_label.text = str(Globals.seconds2hhmmss(song_audio.get_playback_position())," / ",Globals.seconds2hhmmss(song_audio.stream.get_length()))
		else:
			duration_label.text = str(Globals.seconds2hhmmss(last_song_pos)," / ",Globals.seconds2hhmmss(song_audio.stream.get_length()))
		logo.scale = Vector2(1 + AudioServer.get_bus_effect_instance(1, 0).get_magnitude_for_frequency_range(0, 10000).length(),1 + AudioServer.get_bus_effect_instance(1, 0).get_magnitude_for_frequency_range(0, 10000).length())
		play.visible = !song_audio.playing
		stop.visible = song_audio.playing
		progress.max_value = song_audio.stream.get_length()
		if song_audio.playing:
			progress.value = song_audio.get_playback_position()
		elif !song_audio.playing:
			progress.value = last_song_pos

func change_song_selected(song):
	if song != null:
		last_song_pos = 0
		song_selected = song
		for i in songs.get_children():
			i.selected = false
		song.selected = true
		song_played = false
		cur_song_playing.text = str(song.song_name)
		if FileAccess.file_exists(song.song_path):
			var file := FileAccess.open(song.song_path,FileAccess.READ)
			var data = file.get_buffer(file.get_length())
			var stream := AudioStreamMP3.new()
			stream.data = data
			song_audio.set_stream(stream)
			loop.button_pressed = false
		else:
			list_files_in_songs_folder()
			load_song_buttons()
			cur_song_playing.text = "Song file deleted!"

func load_song_buttons():
	for i in songs.get_children():
		i.queue_free()
	
	var pos_y = 5
	for i in all_songs:
		var button := preload("res://scenes/song.tscn").instantiate()
		button.song_name = FindSongs.load_cfg(i,"name")
		button.id = FindSongs.load_cfg(i,"id")
		button.song_path = FindSongs.load_cfg(i,"path")
		button.true_name = i
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
				FindSongs.save_cfg(file.get_file(),"path",str("user://songs/",file.get_file()))
				FindSongs.save_cfg(file.get_file(),"image_path","null")
				FindSongs.save_cfg(file.get_file(),"amount_played",0)
	
	dir.list_dir_end()
	
	all_songs = files
	print(all_songs)

func _on_v_scroll_bar_value_changed(value):
	songs.position.y += prev_scroll_value - value
	prev_scroll_value = value

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Songs"), value)

func _on_plus_ten_button_up():
	if song_audio.playing:
		song_audio.play(song_audio.get_playback_position() + 5)
	else:
		song_audio.play(last_song_pos + 5)
		last_song_pos = song_audio.get_playback_position()
		song_audio.stop()

func _on_minus_ten_button_up():
	if song_audio.playing:
		song_audio.play(song_audio.get_playback_position() - 5)
	else:
		song_audio.play(last_song_pos - 5)
		last_song_pos = song_audio.get_playback_position()
		song_audio.stop()

func _on_loop_toggled(button_pressed):
	song_audio.stream.loop = button_pressed

func _on_stop_button_down():
	last_song_pos = song_audio.get_playback_position()
	song_audio.stop()

func _on_play_button_down():
	song_audio.play(last_song_pos)
	if !song_played and song_selected != null:
		if typeof(FindSongs.load_cfg(song_selected.true_name.get_file(),"amount_played")) == TYPE_STRING:
			Globals.fail_safe("AMOUNT_PLAYED_IS_STRING")
			return
		FindSongs.save_cfg(song_selected.true_name.get_file(),"amount_played",FindSongs.load_cfg(song_selected.true_name.get_file(),"amount_played") + 1)
		song_played = true

func _on_refresh_button_up():
	list_files_in_songs_folder()
	load_song_buttons()

func _on_song_audio_finished():
	song_played = false
