extends Node2D

var quadrado: QuadradoAzul
var velocity: float = 70  # Velocidade em unidades por segundo
var target_distance: float = 140  # Distância total a ser percorrida
var traveled_distance: float = 0  # Distância já percorrida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quadrado = $quadrado_azul


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calcula o deslocamento para este frame
	var step = velocity * delta
	# Atualiza a distância percorrida
	traveled_distance += step
	
	# Move o quadrado apenas enquanto não atingir a distância alvo
	if traveled_distance <= target_distance:
		quadrado.position.x -= step
	else:
		quadrado.position.x -= (target_distance - (traveled_distance - step))
		# Para o movimento quando atingir a distância alvo
		set_process(false)
