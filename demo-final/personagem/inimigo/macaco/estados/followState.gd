extends State
class_name FollowState

@export var enemy: macaco
@export var speed := 170.0

var persRef = preload("res://personagem/metroidvania/character_metroidvania.tscn")
var personagem: CharacterBody2D 
var direction: Vector2
var vectorMove: Vector2

# tempo mínimo no estado follow para entrar no estado ataque
var minTimer = 0.4

func Enter():
	minTimer = 0.6
	personagem = get_tree().get_first_node_in_group("PlayerMetro")
	
func Exit():
	pass

func Update(_delta: float):
	minTimer -= _delta
	
func Physics_Update(_delta: float):
	directionPlayer()
	
	if direction.length() < 400:
		enemy.velocity = vectorMove
	else:
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
# transição idl -> air
func transitionAir():
	if !enemy.is_on_floor():
		Transitioned.emit(self, "air")
func transitionIdle():
	if direction.length() > 600:
		Transitioned.emit(self, "follow")
func transitionAtk():
	if direction.length() < 150 and minTimer < 0:
		Transitioned.emit(self, "atk")
