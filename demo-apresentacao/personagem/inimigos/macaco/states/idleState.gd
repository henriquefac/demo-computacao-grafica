extends State
class_name IdleState


@export var enemy: macaco
@export var speed := 100.0

var persRef = preload("res://personagem/metroidvania/character_metroidvania.tscn")
var personagem: Node 

var init: bool = true

var move_direction : Vector2
var wander_time : float
var stop_time : float
var flag_stop : bool = true

var velocity: Vector2


func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), 0).normalized()
	wander_time = randf_range(2, 3)
	stop_time = randf_range(1,2)
	flag_stop = !flag_stop

func Enter():
	personagem = get_tree().root
	
	if init:
		enemy.wallEsquerda.connect(chengeDirectionToRight)
		enemy.wallDireita.connect(chengeDirectionToLeft)
	init = false
	randomize_wander()

func Update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	elif stop_time > 0:
		stop_time -= delta
		if flag_stop:
			move_direction = Vector2(0,0)
			flag_stop = !flag_stop
			
	else:
		randomize_wander()
		
func Physics_Update(_delta: float):
	velocity = move_direction * speed
	

		
	if enemy:
		enemy.velocity = velocity

	transitionTrigger()

func transitionTrigger():
	transitionAir()
	
# transição idl -> air
func transitionAir():
	if !enemy.is_on_floor():
		Transitioned.emit(self, "air")


func chengeDirectionToRight():
	wander_time += 0.2
	if move_direction.x < 0:
		move_direction.x = 1


func chengeDirectionToLeft():
	wander_time += 0.2
	if move_direction.x > 0:
		move_direction.x = -1
