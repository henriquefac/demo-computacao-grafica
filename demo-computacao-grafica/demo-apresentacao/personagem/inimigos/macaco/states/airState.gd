extends State
class_name airState
# aplicar gravidade quando inimigo estiver no ar

@export var enemy: macaco
@export var gravity := 900.0 

var fall_vctor : Vector2




func Enter():
	pass
	
func Exit():
	enemy.velocity = Vector2(0,0)

func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	enemy.velocity.y += gravity * _delta

	if enemy.is_on_floor():
		Transitioned.emit(self, "idle")
