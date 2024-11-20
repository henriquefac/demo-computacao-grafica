extends State
class_name WalkSatePleyer

@export var playerCharacter: PlayerCharacter

# direcao
var dir: Vector2

# flag pulo
var jump:= true

# timer para transicao
var timer:= 0.2

# area HurtBox
var hurtBox : HurtBoxPlayer

func Enter():
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	dir = Vector2()
	timer = 0.4
	
	pass
	
func Exit():
	pass

func Update(_delta: float):
	timer -= _delta
	checkTimer()
	transictionTrigger()

func checkTimer():
	if Input.is_action_just_released("Direita") or Input.is_action_just_released("Esquerda") or Input.is_action_just_released("Pular"):
		timer = 0.4

func Physics_Update(_delta: float):
	move()
# movimento
func move():
	dir = Vector2()
	if Input.is_action_pressed("Esquerda"):
		dir.x -= 1
	elif Input.is_action_pressed("Direita"):
		dir.x += 1
	playerCharacter.velocity.x = (dir.normalized() * playerCharacter.faceVelocity()).x
	pular()
	
# Função de pulo
func pular():
	jump = playerCharacter.is_on_floor()
	if Input.is_action_just_pressed("Pular") and jump:
		playerCharacter.velocity.y = playerCharacter.faceJump()
		jump = false
	
# transicao para idle
func transictionTrigger():
	transictionIdle()
	pass

func transictionIdle():
	if timer < 0 and playerCharacter.velocity.length() == 0 and jump:
		Transitioned.emit(self, "idle")
	pass


func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy:
		playerCharacter.vectorDirDamage = area.inimigo.dash_dir
		Status.diminuir_vida(area.dano)
		Transitioned.emit(self, "damage")
