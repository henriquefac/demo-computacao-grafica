class_name HitBoxPlayer
extends Area2D

@export var player: PlayerCharacter
@export var dano:= randf_range(5, 10)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func vectorKnock():
	return player.dash_dir * randf_range(150, 300)  + Vector2(0, -200)
