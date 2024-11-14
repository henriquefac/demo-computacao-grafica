extends CharacterBody2D
class_name macaco

# parede esquerda
signal wallEsquerda
signal wallDireita


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

func _ready() -> void:
	esquerda = $esquerda
	direita = $direita
	animationPLayer = $animacao
	frames = $frames
	flagFlip = true
	pass
func _physics_process(delta: float) -> void:
	checkFortWall()
	animation()
	move_and_slide()
	
func animation():
	if velocity.x > 0:
		frames.flip_h = true

	if velocity.x < 0 :
		frames.flip_h = false


	
	if velocity.length() > 0:
		animationPLayer.play("walk")
	else:
		animationPLayer.play("idle")
		
	if velocity.y != 0:
		animationPLayer.stop(true)


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
		
