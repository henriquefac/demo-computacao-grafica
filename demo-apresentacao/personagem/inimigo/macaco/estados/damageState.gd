extends State
class_name DamageState

@export var enemy: macaco
var timer = 10


func Enter():
	timer = 10	
	
func Exit():
	pass
	
func Update(_delta: float):
	timer -= _delta
	if timer < 0:
		Transitioned.emit(self, "idle")
	
