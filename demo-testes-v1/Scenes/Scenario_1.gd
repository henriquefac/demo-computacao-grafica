extends Node2D

var mini_game_active: bool = false

func _ready():
	_start_timer(1.0)

func _start_timer(timer):
	await get_tree().create_timer(timer).timeout
	mini_game_active = false
	if not mini_game_active:
		await _start_mini_game()

func _start_mini_game():
	mini_game_active = true
	
	var mini_game = preload("res://Events/Maini_Game.tscn").instantiate()
	add_child(mini_game)
	
	await mini_game.game_over
	
	_start_timer(randf_range(10,30))
