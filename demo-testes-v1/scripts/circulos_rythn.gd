extends Node2D

# referenciar os dois circulos
var right: Node2D
var left: Node2D

# velocidades
var left_vel = 4
var right_vel = -4
# posicao inicial
var init_cir_1 = Vector2(280,300)
var init_cir_2 = Vector2(420,300)



# conseguir angulo de um para o outro
func get_angle(circ1: Node2D, circ2: Node2D) -> float:
	var pos1 = circ1.position
	var pos2 = circ2.position
	
	# calcular delta
	var delta_x = pos2.x - pos1.x
	var delta_y = pos2.y - pos1.y
	
	var angle = atan2(delta_y, delta_x)
	
	return angle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	right = $right_circle
	left = $left_circle

	

	left.position = init_cir_1
	right.position = init_cir_2
	# alocar velocidades 
	right.orbit_speed = right_vel
	left.orbit_speed = left_vel	
	
	
	
	# atirbuir distancia
	left.set_orbit_distance(right.position.distance_to(left.position))
	right.set_orbit_distance(right.position.distance_to(left.position))
	
	# fazer o circulo left apontar para o alvo como centro de rotação
	left.set_center_circle(right)
	right.set_center_circle(left)
	
	# começar a girar!
	left.girar = false
	right.girar = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interagir"):
		if left.girar:
			left.is_pressed()
		else:
			right.is_pressed()
		

	# Aplicar órbita se estiver girando
	if left.girar and Input.is_action_just_pressed("interagir"):
		left.angle = get_angle(right, left)
	
	if right.girar and Input.is_action_just_pressed("interagir"):
		right.angle = get_angle(left, right)
