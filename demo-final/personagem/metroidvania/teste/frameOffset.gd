extends AnimatedSprite2D

# Última largura do frame de ataque
@export var last_frame_width_atk1: int = 0
@export var last_frame_width_atk2: int = 0
@export var last_frame_width_run: int = 0


func _ready() -> void:
	frame_changed.connect(calculate_offset_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func calculate_offset_attack() -> void:
	if animation == "atk1":
		# Obtemos o frame atual da animação de ataque
		var current_texture = sprite_frames.get_frame_texture("atk1", frame)
		
		if current_texture:
			var current_width = current_texture.get_width()
			# Se for o primeiro frame, apenas armazenamos a largura
			if frame == 0:
				last_frame_width_atk1 = current_width
				offset = Vector2(0,0)
				return
			
			# Se o sprite estiver espelhado (Hflip), ajustamos o offset
			if flip_h:
				offset.x += (last_frame_width_atk1 - current_width)*2

			
			# Atualizamos a última largura para o próximo cálculo
			last_frame_width_atk1 = current_width
	elif animation == "atk2":
		# Obtemos o frame atual da animação de ataque
		var current_texture = sprite_frames.get_frame_texture("atk2", frame)
		
		if current_texture:
			var current_width = current_texture.get_width()
			# Se for o primeiro frame, apenas armazenamos a largura
			if frame == 0:
				last_frame_width_atk2 = current_width
				offset = Vector2(0,0)
				return
			
			# Se o sprite estiver espelhado (Hflip), ajustamos o offset
			if flip_h:
				offset.x += (last_frame_width_atk2 - current_width)*2

			
			# Atualizamos a última largura para o próximo cálculo
			last_frame_width_atk2 = current_width
	elif animation == "run":
		# Obtemos o frame atual da animação de ataque
		var current_texture = sprite_frames.get_frame_texture("run", frame)
		
		if current_texture:
			var current_width = current_texture.get_width()
			# Se for o primeiro frame, apenas armazenamos a largura
			if frame == 0:
				last_frame_width_run = current_width
				offset = Vector2(0,0)
				return
			
			# Se o sprite estiver espelhado (Hflip), ajustamos o offset
			if flip_h:
				offset.x += (last_frame_width_run - current_width)

			
			# Atualizamos a última largura para o próximo cálculo
			last_frame_width_run = current_width
	else:
		# Reseta o offset ao final da animação
		offset = Vector2(0, 0)
