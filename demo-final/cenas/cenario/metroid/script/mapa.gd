extends Node2D

var mini_game_active = false
var score = 0

signal player_in_door
signal player_in_enemy

var player: Node2D

@onready
var camera := $Personagem/Camera2D

@onready
var lockedDoor = $"locked-door"

@export var circle_scene: PackedScene

func _ready() -> void:
	player = get_tree().get_first_node_in_group("PlayerMetro")
	self.connect("player_in_enemy", Callable(self, "_on_player_in_enemy"))
	self.connect("player_in_door", Callable(self, "_on_player_in_door"))

func _on_player_in_enemy(is_enemy: bool) -> void:
	if is_enemy:
		_start_timer(1)  # Inicia o temporizador quando o jogador entra na porta

func _on_player_in_door(is_in_door: bool) -> void:
	if is_in_door:
		_start_timer_door_locked(1)

func _process(delta: float) -> void:
	camera.position = player.position

func _start_timer(timer):
	await get_tree().create_timer(timer).timeout
	mini_game_active = false
	if not mini_game_active:
		await _start_mini_game()

func _start_timer_door_locked(timer):
	await get_tree().create_timer(timer).timeout
	mini_game_active = false
	if not mini_game_active:
		await _start_mini_game_rythme()

func _start_mini_game():
	mini_game_active = true
	get_tree().paused = true
	
	var mini_game = preload("res://events/aim_lab/circle_generator.tscn").instantiate()
	get_parent().add_child(mini_game)
	
	await mini_game.game_over
	
	get_tree().paused = false
	

func _start_mini_game_rythme():
	mini_game_active = true
	get_tree().paused = false
	
	var mini_game = preload("res://testes/matriz/wall.tscn").instantiate()
	get_parent().add_child(mini_game)
	
	mini_game.global_position = camera.global_position
	mini_game.position.y += -275
	mini_game.z_index = 3
	
	await mini_game.game_over
	
	lockedDoor.queue_free()
