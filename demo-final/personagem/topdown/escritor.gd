extends CharacterBody2D

# Variável de velocidade do personagem
var velocidade: float = 100
var player_in_computer: bool = false
var player_in_bed: bool = false
var paused: bool = false

# Frames de animação
var animation_player: AnimatedSprite2D

@onready var pause_menu: Control = $main_ui/PauseMenu

@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene

var transition_instance: CanvasLayer = null

var pausado = false

func _ready() -> void:
	animation_player = $frames  # Referência ao AnimatedSprite2D
	pause_menu.visible = false  # Esconde o menu de pausa inicialmente
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)
	
	self.global_position.x = Status.posX_TD
	self.global_position.y = Status.posY_TD

# Atualiza a física e movimento do personagem
func _physics_process(delta: float) -> void:
	Status.posX_TD = self.global_position.x
	Status.posY_TD = self.global_position.y
	
	if pausado:
		atualizar_animacao(Vector2.ZERO, true)  # Para a animação enquanto pausado
		return # Não processa movimentação enquanto o jogo está pausado

	movimentacao(delta)

	if player_in_computer and Input.is_action_just_pressed("interagir") and Status.esta_vivo():
		_interact_with_computer()

	if player_in_bed and Input.is_action_just_pressed("interagir"):
		paused = !paused
		transition_instance.transition()
		Status.restaurar_vida(100)

		movimentacao(delta)

		await transition_instance.on_transition_finished
		await get_tree().create_timer(0.69444).timeout
		paused = !paused

# Lógica de movimentação do personagem
func movimentacao(delta: float) -> void:
	var movimento = Vector2.ZERO  # Inicializa o vetor de movimento com zero
	
	# Verifica as direções e ajusta o vetor de movimento
	if !paused:
		if Input.is_action_pressed("Cima"):
			movimento.y -= 1
		elif Input.is_action_pressed("Baixo"):
			movimento.y += 1
		if Input.is_action_pressed("Esquerda"):
			movimento.x -= 1
		elif Input.is_action_pressed("Direita"):
			movimento.x += 1

	# Normaliza o vetor de movimento para evitar velocidades diferentes ao mover diagonalmente
	if movimento != Vector2.ZERO:
		movimento = movimento.normalized()

	# Move o personagem com a velocidade ajustada pelo delta
	velocity = movimento * velocidade
	move_and_slide()

	# Atualiza a animação com base no movimento
	atualizar_animacao(movimento, false)

# Função para atualizar a animação
func atualizar_animacao(movimento: Vector2, parado: bool) -> void:
	if parado or movimento == Vector2.ZERO:
		animation_player.stop()  # Para a animação se o personagem não estiver se movendo
		return
	
	# Atualiza a animação conforme a direção do movimento
	if movimento.y < 0:
		animation_player.play("cima")
	elif movimento.y > 0:
		animation_player.play("frente")
	elif movimento.x < 0:
		animation_player.play("esquerda")
	elif movimento.x > 0:
		animation_player.play("direita")

# Lida com a pausa do jogo
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pausar"):
		pausado = !pausado
		pause_menu.visible = pausado
		get_tree().paused = pausado

func _on_bedroomdoor_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://cenas/cenario/topdown/Scenario_1.tscn")

func _on_livingroomdoor_body_entered(body: Node2D) -> void:
	#get_tree().change_scene_to_file("res://cenas/cenario/topdown/Scenario_2.tscn")
	pass

func _on_computer_lvl_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_computer = true

func _on_computer_lvl_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_computer = false

func _on_bed_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_bed = true

func _on_bed_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_bed = false

func _interact_with_computer() -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_file("res://cenas/cenario/metroid/mapa.tscn")

func _on_transition_complete() -> void:
	pass
