extends State
class_name DamageStatePlayer

@export var playerCharacter : PlayerCharacter 
var timer = 0.7

func Enter():
	timer = 0.7
	playerCharacter.velocity = Vector2()
	playerCharacter.HutBoxActivate()
	playerCharacter.velocity.y = -400
	playerCharacter.velocity += playerCharacter.vectorDirDamage * 400
	

	
func Exit():
	pass

func Update(_delta: float):
	timer -= _delta
	if timer < 0:
		Transitioned.emit(self, "idle")
	
func Physics_Update(_delta: float):
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.x += playerCharacter.vectorDirDamage.x * 100 * _delta
	else:
		Transitioned.emit(self, "idle")
	pass
