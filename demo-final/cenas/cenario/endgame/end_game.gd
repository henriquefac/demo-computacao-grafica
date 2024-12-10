extends Node2D

@onready var start_button: Button = $Start_Button as Button
@onready var quit_button: Button = $Quit_Button as Button
@onready var tutorial = preload("res://cenas/cenario/menu/main_menu.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(on_start_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial)

func on_quit_pressed() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
