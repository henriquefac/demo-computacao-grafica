extends Node2D

var radius = 50  # Raio do círculo desejado
signal circle_clicked

@onready var sprite = $Sprite2D
@onready var area = $Area2D

func _ready():
	randomize()
	
	var screen_size = get_viewport().get_camera_2d().get_viewport().size
	position = Vector2(
		randf_range(radius, screen_size.x - radius),
		randf_range(radius, screen_size.y - radius)
	)
	sprite.position = Vector2.ZERO
	area.position = Vector2.ZERO
	sprite.scale = Vector2(2 * radius / sprite.texture.get_size().x, 2 * radius / sprite.texture.get_size().y)

	var shape = CircleShape2D.new()
	shape.radius = radius
	area.get_node("CollisionShape2D").shape = shape

	self.position = position

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("circle_clicked")
		queue_free()
