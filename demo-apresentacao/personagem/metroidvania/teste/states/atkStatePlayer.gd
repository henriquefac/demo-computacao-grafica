extends State
class_name Atk1StatePlayer

@export var playerCharacter: PlayerCharacter
var animationPlayer: AnimationPlayer

# area HurtBox
var hurtBox : HurtBoxPlayer
var on:bool
var secondAttk: bool

func Enter():
	secondAttk = false
	on = true
	
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	
	playerCharacter.is_atk = true
	animationPlayer = playerCharacter.animation
	if not animationPlayer.animation_finished.is_connected(transitionIdle):
		animationPlayer.animation_finished.connect(transitionIdle)
	playerCharacter.velocity = Vector2()
	playerCharacter.is_dashing = true
	animationPlayer.play("atk1")
func Exit():
	on = false
	playerCharacter.is_atk = false
	playerCharacter.is_dashing = false
	
func Update(_delta: float):
	if Input.is_action_just_pressed("Ataque"):
		secondAttk = true
	
func Physics_Update(_delta: float):
	pass


func transitionIdle(arg):
	if arg == "atk1":
		if secondAttk:
			Transitioned.emit(self, "atk2")
		else:
			Transitioned.emit(self, "idle")

func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")
