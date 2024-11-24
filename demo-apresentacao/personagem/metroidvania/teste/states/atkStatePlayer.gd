extends State
class_name AtkStatePlayer

@export var playerCharacter: PlayerCharacter
var animationPlayer: AnimationPlayer

func Enter():
	playerCharacter.is_atk = true
	animationPlayer = playerCharacter.animation
	if not animationPlayer.animation_finished.is_connected(transitionIdle):
		animationPlayer.animation_finished.connect(transitionIdle)
	playerCharacter.velocity = Vector2()
	playerCharacter.is_dashing = true
	animationPlayer.play("atk")
func Exit():
	playerCharacter.is_atk = false
	playerCharacter.is_dashing = false
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass


func transitionIdle(arg):
	Transitioned.emit(self, "idle")
