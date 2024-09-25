extends Node2D

var score = 0
var max_score = 10

signal game_over

@export var circle_scene: PackedScene

func _ready():
	_create_new_circle()

func _create_new_circle():
	if score < max_score:
		var new_circle = circle_scene.instantiate()
		add_child(new_circle)
		new_circle.connect("circle_clicked", Callable(self, "_on_circle_clicked"))
	else:
		emit_signal("game_over")
		queue_free()

func _on_circle_clicked():
	score += 1
	_create_new_circle()
