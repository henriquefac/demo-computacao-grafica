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
var on:bool


func Enter():
	on = true
	if hurtBox == null:
		hurtBox = playerCharacter.hurtBox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	dir = Vector2()
	timer = 0.4
	
	jump = playerCharacter.is_on_floor()
	if Input.is_action_pressed("Pular") and jump:
		playerCharacter.velocity.y = playerCharacter.faceJump()
		jump = false

func Exit():
	on = false

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
	transitionAtk()
	transitionDefend()
	pass

func transitionAtk():
	if Input.is_action_just_pressed("Ataque"):
		Transitioned.emit(self, "atk1")

func transictionIdle():
	if timer < 0 and playerCharacter.velocity.length() == 0 and jump:
		Transitioned.emit(self, "idle")
	pass


func transictionDamage(area: HitBoxEnemy):
	if typeof(area) == TYPE_OBJECT and area is HitBoxEnemy and on:
		playerCharacter.getDamage(area)
		Transitioned.emit(self, "damage")
	
		
func transitionDefend():
	if Input.is_action_just_pressed("Defesa") and playerCharacter.is_on_floor():
		Transitioned.emit(self, "defend")
