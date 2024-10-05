extends Node2D

# Propriedades da órbita
var orbit_radius = 100
var orbit_speed = 1.0  # Velocidade de rotação
var angle = 0.0  # Ângulo da órbita
var girar: bool
signal continue_azul
var new_position: Vector2


# flags
var flag_in_area: bool

# Referência ao outro círculo (direito) para fazer dele o centro de órbita
var center_circle: Node2D

# Raio e cor do círculo
var radius = 50
var color = Color(0.9, 0.1, 0.1)  # Azul por padrão, pode alterar se necessário

func _ready() -> void:
	# Adicionar a bola azul à cen

	flag_in_area = false
	girar = false

# Desenha o círculo
func _draw() -> void:
	draw_circle(Vector2(0, 0), radius, color)

# Inicializa a órbita com referência ao centro do outro círculo (bola esquerda)
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

# Função para parar e emitir o sinal
func is_pressed():
	if flag_in_area:
		girar = false
		position = new_position
		emit_signal("continue_azul")  # Emite o sinal para a bola esquerda



# Função chamada a cada frame
func _process(delta: float) -> void:
	if girar:
		orbit(delta)
	queue_redraw()

# Detecta quando entra em uma área (como colisão com a bola esquerda)
func _on_area_2d_area_entered(area: Area2D) -> void:
	flag_in_area = true
	new_position = area.get_parent().position
# Detecta quando sai de uma área
func _on_area_2d_area_exited(area: Area2D) -> void:
	flag_in_area = false


func _on_left_circle_continue_vermelho() -> void:
	girar = true
