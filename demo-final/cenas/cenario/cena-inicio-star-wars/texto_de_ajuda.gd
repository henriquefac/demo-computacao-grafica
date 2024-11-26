extends Node2D

@onready var start_button: Button = $Button as Button
@onready var start_scene = load("res://cenas/cenario/topdown/Scenario_1.tscn") as PackedScene
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene

var transition_instance: CanvasLayer = null
var elapsed_time: float = 0.0

func _ready() -> void:
	start_button.button_down.connect(on_start_pressed)
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)

func on_start_pressed() -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_packed(start_scene)

func _process(delta: float) -> void:
	# Adiciona o tempo desde o último frame.
	elapsed_time += delta
	
	# Verifica se 20 segundos já se passaram.
	if elapsed_time >= 20.0:
		get_tree().change_scene_to_packed(start_scene)

func _on_transition_complete() -> void:
	pass
