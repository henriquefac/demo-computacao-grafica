class_name HitBoxBoss1
extends Area2D

@export var inimigo: duval
@export var dano = 30
@export var dano2 = 35
@export var x_val_knockBack = 600
@export var y_val_knockBack = 600

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
	return inimigo.dash_dir * x_val_knockBack  + Vector2(0, -y_val_knockBack)
