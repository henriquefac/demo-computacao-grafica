extends State
class_name Atk2StatePlayer


@export var playerCharacter: PlayerCharacter
var animationPlayer: AnimationPlayer

# area HurtBox
var hurtBox : HurtBoxPlayer
var on:bool

func Enter():
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
	animationPlayer.play("atk2")
func Exit():
	on = false
	playerCharacter.is_atk = false
	playerCharacter.is_dashing = false
	playerCharacter.hitBoxArea.disabled = true
func Update(_delta: float):
	transitionGameStart()
	transitionDefend()
	
func Physics_Update(_delta: float):
	pass


func transitionIdle(arg):
	if arg == "atk2":
		Transitioned.emit(self, "idle")

func transictionDamage(area: Area2D):
	if area is not HitBoxBoss1 and area is not HitBoxEnemy:
		return
	if typeof(area) == TYPE_OBJECT and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")

func transitionGameStart():
	if playerCharacter.pause:
		Transitioned.emit(self, "gameStart")

func transitionDefend():
	if Input.is_action_pressed("Defesa"):
		Transitioned.emit(self, "defend")
