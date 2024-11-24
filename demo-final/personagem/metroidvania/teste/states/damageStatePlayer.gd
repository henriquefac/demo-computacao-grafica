extends State
class_name DamageStatePlayer

@export var playerCharacter : PlayerCharacter 
var timer = 0.7

func Enter():
	print("dano")
	timer = 0.7	

	
func Exit():
	pass

func Update(_delta: float):
	timer -= _delta
	if timer < 0:
		Transitioned.emit(self, "idle")
	
func Physics_Update(_delta: float):
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.x += playerCharacter.vectorDirDamage * 100 * _delta
	else:
		Transitioned.emit(self, "idle")
	pass
