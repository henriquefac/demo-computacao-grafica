extends Node2D

var mini_game_active = false

signal player_in_door
signal player_in_enemy
signal player_in_the_end
signal game_start
signal game_paused


var playerInterface: Node2D
var player: PlayerCharacter
var gameOver: bool = false

var start = "res://cenas/cenario/topdown/Scenario_1.tscn"

@onready var camera := $Personagem/Camera2D
@onready var pages_text = $Personagem/PersonagemNode/main_ui
@onready var erros: ColorRect = $Personagem/PersonagemNode/main_ui/Control/Erro
@onready var erros_text: Label = $Personagem/PersonagemNode/main_ui/Control/Erro/Label
@onready var lockedDoor = $"locked-door"
@onready var lockedDoorBody = $mapa/doors
@onready var loockedArea = $mapa/blur
@onready var enemys: Array[Node] = $enemys.get_children()
@onready var maxPages: Array[Node] = $pages.get_children()
@export var circle_scene: PackedScene


func _ready() -> void:
	AudioPlayer.play_music_scene(1)
	
	$endGame_text.visible = false
	Status.win = false
	erros.visible = false
	
	playerInterface = get_tree().get_first_node_in_group("PlayerMetro")
	player = playerInterface.playerNode
	
	self.connect("player_in_enemy", Callable(self, "_on_player_in_enemy"))
	self.connect("player_in_door", Callable(self, "_on_player_in_door"))
	self.connect("player_in_the_end", Callable(self, "_on_gameOver"))
	self.connect("game_paused", Callable(self, "_on_paused_pressed"))
	
	Status.pages = 0
	Status.max_pages = len(maxPages)
	pages_text.max_pages = len(maxPages)

func _on_paused_pressed(paused: bool) -> void:
	if paused:
		if len(enemys) > 0:
			for enemy in enemys:
				if is_instance_of(enemy.get_child(0), CharacterBody2D):
					enemy.get_child(0).paused_ = true
	else:
		if len(enemys) > 0:
			for enemy in enemys:
				if is_instance_of(enemy.get_child(0), CharacterBody2D):
					enemy.get_child(0).paused_ = false
					

func _on_gameOver(gameOver_: bool) -> void:
	if gameOver_:
		gameOver = gameOver_
	else:
		gameOver = gameOver_

func _on_player_in_enemy(is_enemy: bool) -> void:
	if is_enemy:
		_start_timer(1)  # Inicia o temporizador quando o jogador entra na porta

func _on_player_in_door(is_in_door: bool) -> void:
	if is_in_door and Status.pages == 2:
		erros.visible = false
		_start_timer_door_locked(.1)
	elif is_in_door and Status.pages < 2:
		
		# MEXENDO NO ALPHA DA COR (TRANSPARENCIA) e na SATURACAO
		erros.set_color(Color(.7, .1, .1, .6))
		erros.visible = true
		erros_text.set_text("Você sente que deixou algo 
		para trás");

func _process(delta: float) -> void:
	camera.position = player.position
	
	# CONDICAO DE VITORIA
	if Status.max_pages == Status.pages && gameOver:
		Status.win = true
		$endGame_text.visible = true
		player.SPEED = 0
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file(start)

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
	player.pause = true
	mini_game_active = true
	get_tree().paused = true
	
	var mini_game = preload("res://events/aim_lab/circle_generator.tscn").instantiate()
	get_parent().add_child(mini_game)
	
	await mini_game.game_over
	
	get_tree().paused = false
	player.pause = false


func _start_mini_game_rythme():
	lockedDoor.queue_free()
	player.SPEED = 0
	player.pause = true
	mini_game_active = true
	get_tree().paused = false
	
	var mini_game = preload("res://testes/matriz/wall.tscn").instantiate()
	get_parent().add_child(mini_game)
	
	mini_game.global_position = camera.global_position
	mini_game.position.y += -275
	mini_game.z_index = 10
	
	await mini_game.game_over
	player.pause = false
	player.SPEED = 200
	
	#TIRA A GAMBIARRA DA PAREDE INVISIVEL (UM TILE MAP ESCONDIDO)
	lockedDoorBody.get_node("paredeInvisivel").queue_free()
	loockedArea.get_node("secretArea").queue_free()
	lockedDoorBody.get_node("door").play("open")
