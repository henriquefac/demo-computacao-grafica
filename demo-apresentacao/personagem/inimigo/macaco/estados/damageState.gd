extends State
class_name DamageState

@export var enemy: macaco
var timer = 0.7


func Enter():
	timer = 0.7	

	
func Exit():
	pass
	
func Update(_delta: float):
	timer -= _delta
	if timer < 0:
		Transitioned.emit(self, "idle")
	
