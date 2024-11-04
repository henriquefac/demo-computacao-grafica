extends CharacterBody2D

# Variável de velocidade do personagem
var velocidade: float = 100
var player_in_computer: bool = false

# Frames de animação
var animation_player: AnimatedSprite2D

func _ready() -> void:
	animation_player = $frames  # Referência ao AnimatedSprite2D

 # Atualiza a física e movimento do personagem e verifica se o jogador entrou
 # na area do computador e quer comecar a escrever
func _physics_process(delta: float) -> void:
	movimentacao(delta)
	
	if player_in_computer and Input.is_action_just_pressed("interagir"):
		_interact_with_computer()

# Lógica de movimentação do personagem
func movimentacao(delta: float) -> void:
	var movimento = Vector2.ZERO  # Inicializa o vetor de movimento com zero
	
	# Verifica as direções e ajusta o vetor de movimento
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
	atualizar_animacao(movimento)

# Função para atualizar a animação
func atualizar_animacao(movimento: Vector2) -> void:
	if movimento != Vector2.ZERO:
		if movimento.y < 0:
			animation_player.play("cima")
		elif movimento.y > 0:
			animation_player.play("frente")
		elif movimento.x < 0:
			animation_player.play("esquerda")
		elif movimento.x > 0:
			animation_player.play("direita")
	else:
		animation_player.stop()  # Para a animação se o personagem não estiver se movendo


func _on_livingroomdoor_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://cenas/cenario/topdown/Scenario_2.tscn")

func _on_bedroomdoor_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://cenas/cenario/topdown/Scenario_1.tscn")

func _on_computer_lvl_body_entered(body: Node2D) -> void:
	player_in_computer = true

func _on_computer_lvl_body_exited(body: Node2D) -> void:
	player_in_computer = false

func _interact_with_computer() -> void:
	get_tree().change_scene_to_file("res://cenas/cenario/metroid/mapa.tscn")
