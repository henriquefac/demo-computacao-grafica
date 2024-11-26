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
	transitionDefend()
	transitionHeal()
	
func transitionWalk():
	if Input.is_action_pressed("Direita") or Input.is_action_pressed("Esquerda") or Input.is_action_just_pressed("Pular"):
		Transitioned.emit(self, "walk")

func transitionAtk():
	if Input.is_action_just_pressed("Ataque"):
		Transitioned.emit(self, "atk1")

func transitionHeal():
	if Input.is_action_just_pressed("Cura") and Status.dopamina_bar_atual > 0:
		Transitioned.emit(self, "heal")

func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")
		
func transitionDefend():
	if Input.is_action_pressed("Defesa"):
		Transitioned.emit(self, "defend")
