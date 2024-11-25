extends Node2D

@onready var start_button: Button = $Button as Button
@onready var start_scene = load("res://cenas/cenario/topdown/Scenario_1.tscn") as PackedScene

var elapsed_time: float = 0.0

func _ready() -> void:
	start_button.button_down.connect(on_start_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)

func _process(delta: float) -> void:
	# Adiciona o tempo desde o último frame.
	elapsed_time += delta
	
	# Verifica se 20 segundos já se passaram.
	if elapsed_time >= 20.0:
		get_tree().change_scene_to_packed(start_scene)
