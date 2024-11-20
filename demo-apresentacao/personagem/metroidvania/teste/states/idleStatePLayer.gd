extends State
class_name IdleStatePlayer


@export var playerCharacter: PlayerCharacter

# area HurtBox
var hurtBox : HurtBoxPlayer
func Enter():

	# fica parado
	playerCharacter.velocity.x = 0
	
func Exit():
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)

func Update(_delta: float):
	transitionTrigger()
	pass
	
func Physics_Update(_delta: float):
	pass

func transitionTrigger():
	transitionWalk()
	pass
func transitionWalk():
	if Input.is_action_just_pressed("Direita") or Input.is_action_just_pressed("Esquerda") or Input.is_action_just_pressed("Pular"):
		Transitioned.emit(self, "walk")
		

func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy:
		playerCharacter.vectorDirDamage = area.inimigo.dash_dir
		Status.diminuir_vida(area.dano)
		Transitioned.emit(self, "damage")
