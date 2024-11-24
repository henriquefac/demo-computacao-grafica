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

var hurtBox : HurtBoxPlayer
var on = true


func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), 0).normalized()
	wander_time = randf_range(2, 3)
	stop_time = randf_range(1,2)
	flag_stop = !flag_stop

func Enter():
	on = true
	personagem = get_tree().get_first_node_in_group("PlayerMetro")
	
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
	transitionFollow()
	
# transição idl -> air
func transitionAir():
	if !enemy.is_on_floor():
		Transitioned.emit(self, "air")
		
func transitionFollow():
	if directionPlayer().length() < 400:
		Transitioned.emit(self, "follow")
		
func transitionDamage(area: HitBoxPlayer):
	if typeof(area) == TYPE_OBJECT and area is HitBoxPlayer and on:
		pass
func chengeDirectionToRight():
	wander_time += 0.2
	if move_direction.x < 0:
		move_direction.x = 1

func directionPlayer() -> Vector2:
	var direction = (personagem.global_position - enemy.global_position)
	return direction

func chengeDirectionToLeft():
	wander_time += 0.2
	if move_direction.x > 0:
		move_direction.x = -1
		
func Exit():
	on = false
