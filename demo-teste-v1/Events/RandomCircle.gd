extends Node2D

var radius = 50
signal circle_clicked

func _ready():
	randomize()
	var screen_size = get_viewport().size
	position.x = randf_range(radius, screen_size.x - radius)
	position.y = randf_range(radius, screen_size.y - radius)

	call_deferred("_draw")

func _draw():
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0))

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var distance = event.position.distance_to(position)
		if distance <= radius:
			emit_signal("circle_clicked")
			queue_free()
