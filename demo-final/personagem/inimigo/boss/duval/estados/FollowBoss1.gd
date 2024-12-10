extends State
class_name FollowStateBoss1

@export var enemy: duval
@export var speed := 50.0

var persRef = preload("res://personagem/metroidvania/character_metroidvania.tscn")
var personagem: CharacterBody2D 
var direction: Vector2
var vectorMove: Vector2

# tempo mínimo no estado follow para entrar no estado ataque
var minTimer = 0.4

var hurtBox : HurtBoxBoss1
var on = false

func Enter():
	print("Follow")
	on = true
	minTimer = 0.4
	personagem = get_tree().get_first_node_in_group("PlayerMetro").playerNode
	
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
func Exit():
	on = false

func Update(_delta: float):
	minTimer -= _delta
	
func Physics_Update(_delta: float):
	if enemy.vida <= 0:
		return
	directionPlayer()
	if direction.length() < 400:
		enemy.velocity.x = vectorMove.x
	if direction.length() < 60:
		enemy.velocity = Vector2()
	transitionTrigger()
	
	
func directionPlayer():
	direction = (personagem.global_position - enemy.global_position)
	vectorMove = direction.normalized() * speed
	vectorMove.y = 0

func transitionTrigger():
	transitionAir()
	transitionIdle()
	transitionAtk()
	if enemy.vida <= 0:
		Transitioned.emit(self, "death")
		return 
	
# transição idl -> air
func transitionAir():
	if !enemy.is_on_floor():
		Transitioned.emit(self, "air")
func transitionIdle():
	if direction.length() > 300:
		Transitioned.emit(self, "follow")
func transitionAtk():
	if direction.length() < 50 and minTimer < 0:
		Transitioned.emit(self, "atk")
		
func transictionDamage(area: HitBoxPlayer):
	if area.is_in_group("hitboxPlayer") and area is HitBoxPlayer and on:
		print("damage:follow")
		enemy.getDamage(area)
		Transitioned.emit(self, "damage")
		
	if area.is_in_group("hitBoxPlayer2") and area is HitBoxPlayer and on:
		print("damage:follow")
		enemy.getDamage2(area)
		Transitioned.emit(self, "damage")
