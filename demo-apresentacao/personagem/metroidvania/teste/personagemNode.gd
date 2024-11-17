extends CharacterBody2D


# animacao
var animation: AnimationPlayer
var frame: AnimatedSprite2D

const GRAVITY = 1800.0
const MAX_FALL_SPEED = 800.0

var is_on_ground: bool

func _ready() -> void:
	animation = $AnimationPlayer
	frame = $AnimatedSprite2D
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
