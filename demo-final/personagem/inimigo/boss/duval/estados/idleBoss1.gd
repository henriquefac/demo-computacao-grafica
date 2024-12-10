extends State
class_name IdleBoss1


@export var enemy: duval
@export var speed := 170.0

var persRef = preload("res://personagem/metroidvania/character_metroidvania.tscn")
var personagem: CharacterBody2D 

var init: bool = true

var move_direction : Vector2
var wander_time : float
var stop_time : float
var flag_stop : bool = true

var velocity: Vector2

var hurtBox : HurtBoxBoss1
var on = true


func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), 0).normalized()
	wander_time = randf_range(2, 3)
	stop_time = randf_range(1,2)
	flag_stop = !flag_stop

func Enter():
	if enemy.morte:
		Transitioned.emit(self, "death")
	on = true
	personagem = get_tree().get_first_node_in_group("PlayerMetro").playerNode
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	
	if init:
		enemy.wallEsquerda.connect(chengeDirectionToRight)
		enemy.wallDireita.connect(chengeDirectionToLeft)
	init = false
	randomize_wander()

func Update(delta : float):
	if enemy.is_on_floor():
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
	transitionTrigger()
	velocity.x = move_direction.x * speed
		
	if enemy and enemy.is_on_floor():
		enemy.velocity.x = velocity.x

	

func transitionTrigger():
	transitionAir()
	transitionFollow()
	
# transição idl -> air
func transitionAir():
	if !enemy.is_on_floor():
		Transitioned.emit(self, "air")
		
func transitionFollow():
	if directionPlayer().length() < 600 and enemy.is_on_floor():
		Transitioned.emit(self, "follow")
		
func transictionDamage(area: Area2D):
	if area.is_in_group("hitboxPlayer") and area is HitBoxPlayer and on:
		enemy.getDamage(area)
		Transitioned.emit(self, "damage")
	if area.is_in_group("hitBoxPlayer2") and area is HitBoxPlayer and on:
		enemy.getDamage2(area)
		Transitioned.emit(self, "damage")
		
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
