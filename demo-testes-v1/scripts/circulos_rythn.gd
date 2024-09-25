extends Node2D
var lerp_speed = 5.0  # Velocidade da transição
# Referenciar os dois círculos
var right: Node2D
var left: Node2D

# Câmera principal
var camera_main: Camera2D

# Velocidades
var left_vel = 4
var right_vel = -4

# Posições iniciais
var init_cir_1 = Vector2(-70, 0)
var init_cir_2 = Vector2(70, 0)

# Conseguir ângulo de um círculo para o outro
func get_angle(circ1: Node2D, circ2: Node2D) -> float:
	var pos1 = circ1.position
	var pos2 = circ2.position
	
	# Calcular delta
	var delta_x = pos2.x - pos1.x
	var delta_y = pos2.y - pos1.y
	
	var angle = atan2(delta_y, delta_x)
	
	return angle

# Atualizar a posição da câmera para a média entre os dois círculos
func update_camera_position_smooth(delta: float):
	var target_position = (right.position + left.position) / 2.0
	# Suavizar a transição com lerp
	camera_main.global_position = camera_main.global_position.lerp(target_position, lerp_speed * delta)


# Chamada quando o nó entra na árvore de cena
func _ready() -> void:
	camera_main = $camera_main
	
	right = $right_circle
	left = $left_circle

	left.position = init_cir_1
	right.position = init_cir_2
	
	# Alocar velocidades
	right.orbit_speed = right_vel
	left.orbit_speed = left_vel
	
	# Atribuir distância
	left.set_orbit_distance(right.position.distance_to(left.position))
	right.set_orbit_distance(right.position.distance_to(left.position))
	
	# Fazer o círculo left apontar para o alvo como centro de rotação
	left.set_center_circle(right)
	right.set_center_circle(left)
	
	# Começar a girar!
	left.girar = false
	right.girar = true
	
	# Atualizar a câmera inicialmente


# Chamada a cada frame. 'delta' é o tempo decorrido desde o frame anterior.
func _process(delta: float) -> void:
	update_camera_position_smooth(delta)
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
