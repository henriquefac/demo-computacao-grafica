class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var quit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Quit_Button as Button
@onready var start = load ("res://cenas/cenario/cena-inicio-star-wars/texto-de-ajuda.tscn") as PackedScene
@onready var tutorial = load("res://cenas/cenario/tutorial/tutorial.tscn") as PackedScene
@onready var controls = load("res://cenas/cenario/controles/Cena-de-ajuda.tscn") as PackedScene
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene

var transition_instance: CanvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_scene()
	start_button.pressed.connect(on_start_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)

func on_start_pressed() -> void:
	play_transition_and_change_scene(tutorial)

func on_quit_pressed() -> void:
	get_tree().quit()

func play_transition_and_change_scene(scene: PackedScene) -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_packed(scene)

func _on_transition_complete() -> void:
	pass
