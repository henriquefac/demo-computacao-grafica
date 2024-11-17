extends CharacterBody2D
class_name macaco

# parede esquerda
signal wallEsquerda
signal wallDireita


# hitbox, area para dar dano no player
var hitbox: HitBoxEnemy
var x_value_hitbox
var flipHitBox: bool

# raycast esquerdo
var esquerda: RayCast2D
# raycast direito
var direita: RayCast2D


# para parede esquerda
var LeftWall: bool = true
var RightWall: bool = true

# vai armazenar instancia do personagem
var personagem = null


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

func _ready() -> void:
	hitbox = $HitBoxEnemy
	x_value_hitbox = hitbox.position.x
	esquerda = $esquerda
	direita = $direita
	animationPLayer = $animacao
	frames = $frames
	flagFlip = true
	flipHitBox = false
	
	pass
func _physics_process(delta: float) -> void:
	checkFortWall()
	if !is_dashing:
		animation()
	flipBox()
	move_and_slide()
	
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
	print("realizar ataque")

	
	dash_dir = Vector2(-1, 0)
	if flipHitBox:
		dash_dir.x = 1
	velocity = Vector2.ZERO
	
	velocity = velocity.move_toward(dash_dir.normalized() * dash_speed, 300)
	await get_tree().create_timer(dash_duration).timeout
	velocity = Vector2()
