extends AudioStreamPlayer


const scene_music_1 = preload("res://assets/musica/743697__mike_306__elevator-music.wav")
const scene_music_lv1 = preload("res://assets/musica/707884__dave4884__pirates-song.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume_db
	play()
	
func play_music_scene(i=0):
	if i == 0:
		_play_music(scene_music_1)
	if i == 1:
		_play_music(scene_music_lv1)

	
func play_FX(music: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.volume = volume
	fx_player.name = 'FX_PLAYER'
	add_child(fx_player)
	fx_player.play()
	await  fx_player.finished
	fx_player.queue_free()
