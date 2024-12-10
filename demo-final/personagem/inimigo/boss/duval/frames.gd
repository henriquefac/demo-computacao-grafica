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
	
	if animation == "attack":
		# Obtemos o frame atual da animação de ataque
		var current_texture = sprite_frames.get_frame_texture("attack", frame)
		
		if current_texture:
			if frame == 1:
				last_frame_width_atk1 = sprite_frames.get_frame_texture("attack", 0).get_width()
			var current_width = current_texture.get_width()
			print(last_frame_width_atk1 - current_width)
			
			if flip_h:
				offset.x += (last_frame_width_atk1 - current_width)
			else:
				offset.x -= (last_frame_width_atk1 - current_width)
			
			last_frame_width_atk1 = current_width	
	elif animation == "distance attack":
		# Obtemos o frame atual da animação de ataque
		var current_texture = sprite_frames.get_frame_texture("distance attck", frame)
	
		if current_texture:
			if frame == 1:
				last_frame_width_atk2 = sprite_frames.get_frame_texture("distance attck", 0).get_width()
			var current_width = current_texture.get_width()
			print(last_frame_width_atk1 - current_width)
			
			if flip_h:
				offset.x += (last_frame_width_atk2 - current_width)
			else:
				offset.x -= (last_frame_width_atk2 - current_width)
			last_frame_width_atk2 = current_width	
		
	else:
		offset = Vector2()
