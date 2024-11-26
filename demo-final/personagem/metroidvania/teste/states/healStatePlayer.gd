extends State
class_name HealStatePlayer
# player
@export var playerCharacter: PlayerCharacter

# registrar dano
var hurtBox : HurtBoxPlayer
var on:bool

var animation: AnimationPlayer

func Enter():
	on = true
	if Status.dopamina_bar_atual < 0:
		Transitioned.emit(self, "idle")
	else:
		Status.diminuir_dopamina(1)
	
	
	playerCharacter.is_heal = true
	playerCharacter.velocity = Vector2()
	
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if !hurtBox.area_entered.is_connected(transitionDamage):
		hurtBox.area_entered.connect(transitionDamage)
	
	if animation == null:
		animation = playerCharacter.animation
	if !animation.animation_finished.is_connected(transitionIdle):
		animation.animation_finished.connect(transitionIdle)
	
	animation.play("heal")
func Exit():
	on = false
	playerCharacter.is_heal = false
	playerCharacter.hitBoxArea2.disabled = true
	playerCharacter.hurtboxArea.disabled = false
	
func Update(_delta):
	
	if Input.is_action_just_released("Cura"):
		Transitioned.emit(self, "idle")
	transitionGameStart()

func transitionDamage(area: Area2D):
	if area.is_in_group("HitBoxEnemy") and area is HitBoxEnemy and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")

func transitionIdle(animation):
	if animation == "heal":
		Status.restaurar_vida(20)
		Transitioned.emit(self, "idle")


func transitionGameStart():
	if playerCharacter.pause:
		Transitioned.emit(self, "gameStart")
