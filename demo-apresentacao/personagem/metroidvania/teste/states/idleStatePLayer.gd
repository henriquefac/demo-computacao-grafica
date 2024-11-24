extends State
class_name IdleStatePlayer


@export var playerCharacter: PlayerCharacter

# area HurtBox
var hurtBox : HurtBoxPlayer
var on:bool

func Enter():
	on = true
	# fica parado
	playerCharacter.velocity.x = 0
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)

func Exit():
	on = false

func Update(_delta: float):
	transitionTrigger()
	pass
	
func Physics_Update(_delta: float):
	pass

func transitionTrigger():
	transitionWalk()
	transitionAtk()
func transitionWalk():
	if Input.is_action_pressed("Direita") or Input.is_action_pressed("Esquerda") or Input.is_action_just_pressed("Pular"):
		Transitioned.emit(self, "walk")

func transitionAtk():
	if Input.is_action_just_pressed("Ataque"):
		playerCharacter.is_atk = true
		Transitioned.emit(self, "atk")

func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")
