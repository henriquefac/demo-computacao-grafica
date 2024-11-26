extends State
class_name HealStatePlayer
# player
@export var playerCharacter: PlayerCharacter

# registrar dano


var animation: AnimationPlayer

func Enter():

	if Status.dopamina_bar_atual < 0:
		Transitioned.emit(self, "idle")
	else:
		Status.diminuir_dopamina(1)
	
	
	playerCharacter.is_heal = true
	playerCharacter.velocity = Vector2()

	
	if animation == null:
		animation = playerCharacter.animation
	if !animation.animation_finished.is_connected(transitionIdle):
		animation.animation_finished.connect(transitionIdle)
	
	animation.play("heal")
func Exit():
	playerCharacter.is_heal = false
	playerCharacter.hitBoxArea2.disabled = true
	playerCharacter.hurtboxArea.disabled = false
	
func Update(_delta):
	transitionGameStart()



func transitionIdle(animation):
	if animation == "heal":
		Status.restaurar_vida(33.33)
		Transitioned.emit(self, "idle")


func transitionGameStart():
	if playerCharacter.pause:
		Transitioned.emit(self, "gameStart")
