extends State
class_name DamageState

@export var enemy: macaco
var timer = 0.4

var hurtBox : HurtBoxEnemy
var on = true

func Enter():
	enemy.playSound()
	timer = randf_range(0,3)
	on = true
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	

func Exit():
	on = false

	
func Update(_delta: float):
	if enemy.is_on_floor():
		timer -= _delta
	if timer <= 0:
		Transitioned.emit(self, "idle")
	
func Physics_Update(_delta: float):
	if not enemy.is_on_floor():
		enemy.velocity.x += enemy.vectorDirDamage * 100 * _delta
	else:
		Transitioned.emit(self, "idle")
	pass
	
func transictionDamage(area: HitBoxPlayer):
	if area.is_in_group("hitboxPlayer") and area is HitBoxPlayer and on:
		enemy.getDamage(area)
		Transitioned.emit(self, "damage")
