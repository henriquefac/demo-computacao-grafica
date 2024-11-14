extends AnimationPlayer

func _ready() -> void:
	var anim = get_animation("ataque")
	var total_frames = anim.track_get_key_count(1)
	
	var base_duration = 1.0  # Duração total desejada para a animação (em segundos)
	var min_duration = 0.05  # Duração mínima para os frames de impacto
	var max_duration = 0.15  # Duração máxima para os frames mais lentos
	
	# Calcula os tempos de duração dos frames usando uma curva senoidal
	var durations = []
	for i in range(total_frames):
		# Distribui os frames numa curva senoidal para que os frames 4 e 5 sejam mais rápidos
		var t = float(i) / (total_frames - 1) * PI  # Calcula um valor entre 0 e PI
		var duration = lerp(max_duration, min_duration, sin(t))
		durations.append(duration)
	
	# Define o tempo acumulado para cada frame
	var current_time = 0.0
	for i in range(total_frames):
		current_time += durations[i]
		anim.track_set_key_time(1, i, current_time)
	
	# Ajusta a duração total da animação para corresponder ao tempo acumulado
	anim.length = current_time
	print("Duração total da animação:", anim.length)
