extends Node2D

# Propriedades da órbita
var orbit_radius = 100
var orbit_speed = 1.0  # Velocidade de rotação
var angle = 0.0  # Ângulo da órbita
var girar: bool = false
signal continueCircle


# posição para encaichar
var new_position: Vector2

# Preload do outro círculo


# Flags
var flag_in_area: bool = false

# Referência ao outro círculo
var center_circle: Node2D

# Propriedades do círculo
var radius = 25
var color = Color(0.2, 0.8, 0.9)

func _ready() -> void:

	# Inicializa a flag
	flag_in_area = false
	girar = false

# Desenha o círculo
func _draw() -> void:
	draw_circle(Vector2(0, 0), radius, color)

# Inicializa o centro da órbita
func set_center_circle(other_circle: Node2D) -> void:
	center_circle = other_circle

# Define a distância da órbita
func set_orbit_distance(valor: float) -> void:
	orbit_radius = valor

# Atualiza a posição do círculo em órbita
func orbit(delta: float) -> void:
	# Atualiza o ângulo com base na velocidade da órbita
	angle += orbit_speed * delta

	# Calcula a nova posição em torno do centro do outro círculo
	if center_circle:
		var new_x = center_circle.position.x + orbit_radius * cos(angle)
		var new_y = center_circle.position.y + orbit_radius * sin(angle)
		position = Vector2(new_x, new_y)

# Verifica se o botão foi pressionado
func is_pressed():
	if flag_in_area and girar:
		print(new_position)
		girar = false
		position = new_position
		continueCircle.emit()

# Função chamada a cada frame
func _process(delta: float) -> void:
	# Conectar o sinal 'continue_azul' dinamicamente se necessário
	if girar:
		orbit(delta)
	queue_redraw()


	
# Detecta entrada em uma área
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Celula"):
		flag_in_area = true
		new_position = area.get_parent().position

# Detecta saída de uma área
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Celula"):
		flag_in_area = false





func _on_right_continue_circle() -> void:
	girar = true


func _on_left_continue_circle() -> void:
	girar = true
