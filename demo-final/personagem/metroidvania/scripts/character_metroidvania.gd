extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400
const GRAVITY = 900.0  # Força da gravidade aplicada ao personagem
const MAX_FALL_SPEED = 800.0  # Velocidade máxima de queda
var animacao: AnimatedSprite2D
var is_on_ground: bool = false

@onready
var camera := $Camera2D
@onready 
var punch_effect = preload("res://assets/musica/493914__damnsatinist__light-punch.wav")

func _ready() -> void:
	animacao = $animacao
	Status.zooms = camera.zoom

# Função de animação
func animated_(vetor_movimento: Vector2):
	
	if Input.is_action_pressed("Ataque"):
		animacao.play("attack")
		AudioPlayer.play_FX(punch_effect, -12)
		animacao.flip_h = vetor_movimento.x < 0
		return
	
	if not is_on_ground:
		animacao.play("jump")
		animacao.flip_h = vetor_movimento.x < 0
		return
	
	if vetor_movimento.x != 0  and is_on_ground and !Input.is_action_just_pressed("Pular"):
		if Input.is_action_pressed("Correr"):
			animacao.play("run")
		else:
			animacao.play("walk")
		animacao.flip_h = vetor_movimento.x < 0
		return
	
	if vetor_movimento == Vector2.ZERO:
		animacao.play("idle")
	
	pular(vetor_movimento)
	

# Movimentação
func caminhar():
	# vetor de caminhada
	var caminhada = Vector2.ZERO
	
	# verificar esquerda
	if Input.is_action_pressed("Esquerda"):
		caminhada.x -= 1
	if Input.is_action_pressed("Direita"):
		caminhada.x += 1
	
	if caminhada != Vector2.ZERO:
		caminhada = caminhada.normalized()
	
	velocity.x = caminhada.x * SPEED

# Função de pulo
func pular(vetor_movimento: Vector2):
	animacao.flip_h = vetor_movimento.x < 0
	
	if Input.is_action_just_pressed("Pular") and is_on_ground:
		velocity.y = JUMP_VELOCITY
		animacao.play("jump")

# Física do personagem
func _physics_process(delta: float) -> void:
	# Atualiza se o personagem está no chão
	is_on_ground = is_on_floor()

	# Aplica a gravidade quando não estiver no chão
	if not is_on_ground:
		velocity.y += GRAVITY * delta
	
	# Limitar a velocidade máxima de queda
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	# Movimentação horizontal
	caminhar()
	
	# Controla a animação
	animated_(velocity)
	
	# Movimenta o personagem
	move_and_slide()

func _on_lockeddoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().emit_signal("player_in_door", true)

func _on_aim_lab_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().emit_signal("player_in_enemy", true)
