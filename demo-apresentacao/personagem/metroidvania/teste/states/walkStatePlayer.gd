extends State
class_name WalkSatePleyer

@export var playerCharacter: CharacterBody2D
@export var SPEED:=200
@export var JUMP_VELOCITY := -400
# direcao
var dir: Vector2

# flag pulo
var jump:= true

# timer para transicao
var timer:= 0.2
func Enter():
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
	playerCharacter.velocity.x = (dir.normalized() * SPEED).x
	pular()
	
# Função de pulo
func pular():
	jump = playerCharacter.is_on_floor()
	if Input.is_action_just_pressed("Pular") and jump:
		playerCharacter.velocity.y = JUMP_VELOCITY
		jump = false
	
# transicao para idle
func transictionTrigger():
	transictionIdle()
	pass

func transictionIdle():
	if timer < 0 and playerCharacter.velocity.length() == 0 and jump:
		Transitioned.emit(self, "idle")
	pass
