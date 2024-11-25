extends State
class_name DamageState

@export var enemy: macaco
var timer = 0.4

var hurtBox : HurtBoxEnemy
var on = true

func Enter():
	timer = 0.4	
	on = true
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	

func Exit():
	if enemy.vida <= 0:
		enemy.queue_free()
	
func Update(_delta: float):
	timer -= _delta
	if timer < 0 and enemy.is_on_floor():
		Transitioned.emit(self, "idle")
	
func Physics_Update(_delta: float):
	if not enemy.is_on_floor():
		enemy.velocity.x += enemy.vectorDirDamage * 100 * _delta
	else:
		Transitioned.emit(self, "idle")
	pass
	
func transictionDamage(area: HitBoxPlayer):
	if typeof(area) == TYPE_OBJECT and area is HitBoxPlayer and on:
		enemy.getDamage(area)
		Transitioned.emit(self, "damage")
