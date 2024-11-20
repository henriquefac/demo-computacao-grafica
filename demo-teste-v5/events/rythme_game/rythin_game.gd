extends Node2D

# círculos
var circulos: Node2D
var left_circle: Node2D
var right_circle: Node2D
# posição inicial dos quadrados
var position_circulo: Vector2

# quadrados azul
var quadrado_azul_scene = preload("res://events/rythme_game/quadrado_azul.tscn")
# quadrados vermelhos
var quadrado_vermelho_scene = preload("res://events/rythme_game/quadrado_vermelho.tscn")

# matriz size
var largura: int = 10
var altura: int = 10

var porcao: int = 9
# direções possíveis (direita e cima)
var array_direcoes: Array = [Vector2(1, 0), Vector2(0, -1)]  # Direita e Cima

# outras direções (direita e baixo)
var direcoes_alternadas: Array = [Vector2(1, 0), Vector2(0, 1)]

# flag trocar direções (se true, usa direções normal, se não alternada
var flag_dir = true
# arrays de subidas e passadas
var array_comands: Array = []

# posição do quadrado atual
var quadrado_position: Vector2


# posições ocupadas
var posicoes_ocupadas: Array

# ajusta a distância entre quadrados
const DISTANCIA_ENTRE_QUADRADOS: int = 140


# array que segura os quadrados
var array_quadrados_segurados: Array
# Função chamada quando o node entra na cena
func _ready() -> void:
	# Inicializa comandos baseados na largura e altura
	for i in range(largura- 1):
		array_comands.append(0)  # Movimento para a direita
	for i in range(altura - 1):
		array_comands.append(1)  # Movimento para cima
	
	# Embaralha os comandos
	array_comands.shuffle()
	
	# Pega o nó circulos
	circulos = $circulos_rythn
	left_circle  =$circulos_rythn/left_circle
	right_circle = $circulos_rythn/right_circle
	
	position_circulo = circulos.position
	
	# Primeiro quadrado instanciado (vermelho)
	var quadrado_atual = quadrado_vermelho_scene.instantiate()
	quadrado_atual.z_index = 0
	quadrado_atual.position = Vector2(position_circulo.x + 70, position_circulo.y)
	quadrado_position = quadrado_atual.position
	add_child(quadrado_atual)
	array_quadrados_segurados.append(quadrado_atual)
	
	# Adiciona a posição inicial ao conjunto de posições ocupadas
	
	# Gera os próximos quadrados
	var i = 0
	while len(array_comands) > 0:  # Gera até 9 quadrados adicionais
		if i%porcao == 0:
			flag_dir = !flag_dir
			porcao = randi_range(4, 14)
			if i % 2 == 0:
				add_quadrado_azul(Vector2(1, 0))
				add_quadrado_vermelho(Vector2(1, 0))
				i += 1
			else:
				add_quadrado_vermelho(Vector2(1, 0))
				add_quadrado_azul(Vector2(1, 0))
				i += 1
		else:
			if i % 2 == 0:
				add_quadrado_azul()
			else:
				add_quadrado_vermelho()
		
		i += 1


# Escolher aleatoriamente uma direção válida
func get_random_direction() -> Vector2:
	var comando = array_comands.pop_front()
	if flag_dir:
		return array_direcoes[comando]
	else:
		return direcoes_alternadas[comando]

# Verifica se a nova posição já está ocupada
func is_position_occupied(position: Vector2) -> bool:
	return posicoes_ocupadas.has(position)

# Criar e adicionar novo quadrado vermelho
func add_quadrado_vermelho(direcao = null):
	var new_qdrd = quadrado_vermelho_scene.instantiate()
	new_qdrd.z_index = 0
	
	# Pega uma direção válida aleatória
	if direcao == null:
		direcao = get_random_direction()
	
	# Atualiza a posição do quadrado
	var nova_posicao = quadrado_position + direcao * DISTANCIA_ENTRE_QUADRADOS
	
	# Verifica se a posição não está ocupada
	if not is_position_occupied(nova_posicao):
		quadrado_position = nova_posicao
		new_qdrd.position = quadrado_position
		add_child(new_qdrd)
		array_quadrados_segurados.append(new_qdrd)
# Marca a posição como ocupada


# Criar e adicionar novo quadrado azul
func add_quadrado_azul(direcao = null):
	var new_qdrd = quadrado_azul_scene.instantiate()
	new_qdrd.z_index = 0
	
	# Pega uma direção válida aleatória
	if direcao == null:
		direcao = get_random_direction()
	
	# Atualiza a posição do quadrado
	var nova_posicao = quadrado_position + direcao * DISTANCIA_ENTRE_QUADRADOS
	
	# Verifica se a posição não está ocupada
	if not is_position_occupied(nova_posicao):
		quadrado_position = nova_posicao
		new_qdrd.position = quadrado_position
		add_child(new_qdrd)
		array_quadrados_segurados.append(new_qdrd)
  # Marca a posição como ocupada


func _on_circulos_rythn_troca() -> void:
	print(len(array_quadrados_segurados))
	if len(array_quadrados_segurados) > 0:
		array_quadrados_segurados[0].queue_free()
		array_quadrados_segurados.pop_front()
	if left_circle.orbit_speed < 6:
		var dif = 3/left_circle.orbit_speed 
		left_circle.orbit_speed += 0.2 * dif
		right_circle.orbit_speed -= 0.2 * dif
