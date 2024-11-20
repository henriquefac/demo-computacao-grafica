extends CharacterBody2D
class_name PlayerCharacter

@export var SPEED:=200
@export var JUMP:=-400
var aux:Array

# vetor direção
var vectorDirDamage: Vector2

# animacao
var animation: AnimationPlayer
var frame: AnimatedSprite2D

const GRAVITY = 1800.0
const MAX_FALL_SPEED = 800.0

var is_on_ground: bool

var hurtBox: HurtBoxPlayer

func _ready() -> void:
	for i in range(10):
		aux.append(0)
	animation = $AnimationPlayer
	frame = $AnimatedSprite2D
	
	hurtBox = $HurtBoxPlayer
func _physics_process(delta: float) -> void:
	
	animationControl()
		# Atualiza se o personagem está no chão
	is_on_ground = is_on_floor()

	# Aplica a gravidade quando não estiver no chão
	if not is_on_ground:
		velocity.y += GRAVITY * delta

	move_and_slide()



func animationControl():
	if velocity.x > 0:
		frame.flip_h = false
	if velocity.x < 0:
		frame.flip_h = true		
	
	if velocity.length() > 0:
		pass
	else:
		animation.play("idle")

# o que acontece quando é atingido
func HutBoxActivate():
	velocity = Vector2.ZERO
	



# criar funções que controlam os status do personagem
func faceVelocity():
	return SPEED + aux[0]

func faceJump():
	return JUMP + aux[1]
