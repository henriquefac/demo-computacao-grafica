extends CanvasLayer

@onready var close: Button = $close as Button
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene
@onready var topdown = load("res://cenas/cenario/topdown/Scenario_1.tscn") as PackedScene

var transition_instance: CanvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close.pressed.connect(on_close_pressed)
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_close_pressed() -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_packed(topdown)

func _on_transition_complete() -> void:
	pass
