extends State
class_name DefendStatePlayer

@export var playerCharacter: PlayerCharacter
var animationPLayer: AnimationPlayer

# area HurtBox
var hurtBox : HurtBoxPlayer
var on:bool

var timerDamage = 0.3 

func Enter():
	
	playerCharacter.velocity = Vector2()
	playerCharacter.is_defend = true
	playerCharacter.animation.play("defend")
	on = true
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if !hurtBox.area_entered.is_connected(damageDefend):
		hurtBox.area_entered.connect(damageDefend)
func Exit():
	on = false
	playerCharacter.is_defend = false
func Update(_delta):
	if Input.is_action_just_released("Defesa"):
		Transitioned.emit(self, "idle")
	
	timerDamage -= _delta
	if timerDamage <= 0:
		playerCharacter.velocity = Vector2()
	transitionGameStart()

func damageDefend(area: HitBoxEnemy):
	if area.is_in_group("HitBoxEnemy") and area is HitBoxEnemy and on:
		timerDamage = 0.3
		playerCharacter.getDefendDamage(area)

func transitionGameStart():
	if playerCharacter.pause:
		Transitioned.emit(self, "gameStart")
