extends State
class_name AtkState

@export var enemy: macaco

var animationNode: AnimationPlayer


func Enter():
	animationNode = enemy.animationPLayer

	if not animationNode.is_connected("animation_finished",  transitionIdle):
		animationNode.connect("animation_finished", transitionIdle)
		
	enemy.velocity = Vector2()
	enemy.is_dashing = true
	animationNode.play("ataque")

func transitionIdle(algo):
	Transitioned.emit(self, "idle")

func Exit():
	enemy.is_dashing = false
	enemy.velocity = Vector2()

func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
