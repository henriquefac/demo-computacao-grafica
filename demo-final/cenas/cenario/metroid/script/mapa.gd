extends Node2D

var player: Node2D
var camera: Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("PlayerMetro")
	camera = $Personagem/Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position = player.position
