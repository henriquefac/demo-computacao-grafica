class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var quit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Quit_Button as Button
@onready var start = load("res://cenas/cena-inicio-star-wars/texto-de-ajuda.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_scene()
	start_button.button_down.connect(on_start_pressed)
	quit_button.button_down.connect(on_quit_pressed)

func on_start_pressed() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_packed(start)

func on_quit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
