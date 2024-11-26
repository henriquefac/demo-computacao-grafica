extends State
class_name InGameStatePLayer

@export var playerCharacter:PlayerCharacter

func Enter():
	print("GameStart")
	

func Exit():
	pass

func Update(_delta):
	transictionIdle()

func transictionIdle():
	if not playerCharacter.pause:
		Transitioned.emit(self, "idle")
