extends CharacterBody2D
class_name macaco

# parede esquerda
signal wallEsquerda
signal wallDireita

var vida = 100
@export var gravity := 900.0 
# ver de knockback
var vectorDirDamage: float

# sound player
var soudPlayerHit: AudioStreamPlayer2D

# hitbox, area para dar dano no player
var hitbox: HitBoxEnemy
var x_value_hitbox
var flipHitBox: bool

# area para inimigo levar dano
var hurtbox: HurtBoxEnemy

# raycast esquerdo
var esquerda: RayCast2D
# raycast direito
var direita: RayCast2D


# para parede esquerda
var LeftWall: bool = true
var RightWall: bool = true

# vai armazenar instancia do personagem
var personagem = null
var hitBoxArea: CollisionShape2D

var state_machine: StateMachine
var states: Dictionary = {}

# nó de animação
var animationPLayer:AnimationPlayer = null
var frames: AnimatedSprite2D 

var flagFlip: bool

# Propriedades para dash
var dash_speed = 600
var dash_duration = 0.4  # Duração do dash em segundos
var is_dashing = false
var dash_dir = Vector2.ZERO

var atk_on = false

func _ready() -> void:
	soudPlayerHit = $soundDamage
	
	hitbox = $HitBoxEnemy
	hurtbox = $HurtBoxEnemy
	x_value_hitbox = hitbox.position.x
	esquerda = $esquerda
	direita = $direita
	animationPLayer = $animacao
	frames = $frames
	flagFlip = true
	flipHitBox = false
	
	hitBoxArea = $HitBoxEnemy/hitbox
	pass
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	checkFortWall()
	if !is_dashing and !atk_on and is_on_floor():
		animation()
	flipBox()
	move_and_slide()
	
	if is_on_floor() and vida <= 0:
		queue_free()

func playSound():
	soudPlayerHit.play()

func animation():
	if velocity.x > 0:
		frames.flip_h = true
		flipHitBox = true
	if velocity.x < 0 :
		frames.flip_h = false
		flipHitBox = false


	
	if velocity.length() > 0:
		animationPLayer.play("walk")
	else:
		animationPLayer.play("idle")
		
	if velocity.y != 0:
		animationPLayer.stop(true)

func flipBox():
	if flipHitBox:
		hitbox.position.x = -1* x_value_hitbox
	else:
		hitbox.position.x = x_value_hitbox

func checkFortWall():
	if esquerda.is_colliding() and LeftWall:
		LeftWall = false
		wallEsquerda.emit()
	elif !esquerda.is_colliding() and !LeftWall:
		LeftWall = true
		
	if direita.is_colliding() and RightWall:
		RightWall = false
		wallDireita.emit()
	elif !direita.is_colliding() and !RightWall:
		RightWall = true
		
# realizar animacão de ataque
# quando realizar o ataque, personagem se move suavemente para adireção
# atual
# Propriedades para dash
#var dash_speed = 300
#var dash_duration = 0.2  # Duração do dash em segundos
#var is_dashing = false
#var dash_dir = Vector2.ZERO

func atkMove():
	is_dashing = true
	dash_dir = Vector2(-1, 0)
	if flipHitBox:
		dash_dir.x = 1
	velocity = Vector2.ZERO
	
	velocity = velocity.move_toward(dash_dir.normalized() * dash_speed, 300)

func stopAtkMove():
	is_dashing = false
	velocity.x = 0
		
func getDamage(area: HitBoxPlayer):
	
	velocity = Vector2()
	velocity = area.vectorKnock()
	if randf() < 0.2:
		velocity.y = 0
		velocity.x *= 0.5
	vectorDirDamage = velocity.normalized().x
	vida -= area.dano

# receber dano


func getDamage2(area: HitBoxPlayer):
	# Calcula a direção normalizada entre o inimigo (self) e o jogador
	var dir = (global_position - area.player.global_position).normalized()
	
	# Determina se o inimigo está à esquerda ou à direita da área do jogador
	if position.x < area.player.position.x:
		print("Inimigo está à esquerda da área")
	else:
		print("Inimigo está à direita da área")
	
	# Ajusta a direção para o vetor oposto e define a velocidade
	dir *= 600  # Amplia o vetor
	dir.y = -400  # Ajusta o componente vertical para um impulso
	velocity = dir  # Aplica a nova velocidade
	
	# Reduz a vida do inimigo com base no dano da área
	vida -= area.dano
