extends CharacterBody2D
class_name PlayerCharacter

# receber status
signal STATUS_ON

@export var SPEED:=250
@export var JUMP:=-500
var aux:Array

# vetor direção
var vectorDirDamage: int

# direção da hitbox
const x_value_hitbox = 36
var flipHitBox:bool = false

# animacao
var animation: AnimationPlayer
var frame: AnimatedSprite2D

const GRAVITY = 1800.0
const MAX_FALL_SPEED = 800.0

var is_on_ground: bool

# registrar ataks inimigos no player
var hurtBox: HurtBoxPlayer

var hitBox: HitBoxPlayer

# Propriedades para dash
var dash_speed = 200
var dash_duration = 0.4  # Duração do dash em segundos
var is_atk:bool = false
var is_dashing:bool = false
var dash_dir = Vector2.ZERO
var is_defend: bool = false
func _ready() -> void:
	for i in range(10):
		aux.append(0)
	animation = $AnimationPlayer
	frame = $AnimatedSprite2D
	
	hurtBox = $HurtBoxPlayer
	hitBox = $HitBoxPlayer
func _physics_process(delta: float) -> void:
	if !is_atk and !is_dashing and !is_defend:
		animationControl()
	flipBox()
		# Atualiza se o personagem está no chão
	is_on_ground = is_on_floor()

	# Aplica a gravidade quando não estiver no chão
	if not is_on_ground:
		velocity.y += GRAVITY * delta
		
	move_and_slide()



func animationControl():
	if velocity.x > 0:
		frame.flip_h = true
		flipHitBox = false
	if velocity.x < 0:
		frame.flip_h = false		
		flipHitBox = true
	if velocity.length() > 0:
		animation.play("run")
	else:
		animation.play("idle")



func flipBox():
	if flipHitBox:
		hitBox.position.x = -1* x_value_hitbox
	else:
		hitBox.position.x = x_value_hitbox
		

func getDamage(area: HitBoxEnemy):
	
	var statusAply = area.getStatus()
	if statusAply:
		STATUS_ON.emit(statusAply)
	
	velocity = area.vectorKnock()
	vectorDirDamage = velocity.normalized().x
	Status.diminuir_vida(area.dano)

func getDefendDamage(area: HitBoxEnemy):

	velocity = area.vectorKnock()
	velocity.y = 0
	velocity.x *= 0.33
	vectorDirDamage = velocity.normalized().x
	Status.diminuir_vida(area.dano/3)

# criar funções que controlam os status do personagem
func faceVelocity():
	return SPEED + aux[0]

func faceJump():
	return JUMP + aux[1]
	
	
# funcao de atk
# script basico de ataque
func atkProcess():
	is_dashing = true
	dash_dir = Vector2(1, 0)
	if flipHitBox:
		dash_dir.x = -1
	velocity = Vector2.ZERO
	
	velocity = velocity.move_toward(dash_dir.normalized() * dash_speed, 1000)

func stopAtkProcess():
	is_dashing = false
	velocity = Vector2()