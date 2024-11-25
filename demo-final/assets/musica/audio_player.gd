extends AudioStreamPlayer

const scene_music = preload("res://assets/musica/743697__mike_306__elevator-music.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	autoplay = true
	stream_paused = false
	volume_db = volume_db
	play()



func _on_loop_sound(player):
	player.stream_paused = false
	
func play_music_scene():
	_play_music(scene_music)
	
func play_FX(music: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.volume = volume
	fx_player.name = 'FX_PLAYER'
	add_child(fx_player)
	fx_player.play()
	await  fx_player.finished
	fx_player.queue_free()
