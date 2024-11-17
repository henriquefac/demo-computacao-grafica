extends State
class_name IdleStatePlayer


@export var playerCharacter: CharacterBody2D


func Enter():
	# fica parado
	playerCharacter.velocity.x = 0
	
func Exit():
	pass

func Update(_delta: float):
	transitionTrigger()
	pass
	
func Physics_Update(_delta: float):
	pass

func transitionTrigger():
	transitionWalk()
	pass
func transitionWalk():
	if Input.is_action_just_pressed("Direita") or Input.is_action_just_pressed("Esquerda") or Input.is_action_just_pressed("Pular"):
		Transitioned.emit(self, "walk")
