class_name HitBoxBoss1
extends Area2D

@export var inimigo: duval
@export var dano = 30


var efeitoStatus: StatusEfect


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# vetor de knockback
func getStatus():
	efeitoStatus = StatusSlow.new()
	efeitoStatus.SetDuration(0.8)
	return efeitoStatus

	
func vectorKnock():
	return inimigo.dash_dir * 600  + Vector2(0, -600)
