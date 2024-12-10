extends State
class_name DamageBoss1

@export var enemy: duval
var timer = 0.4

var hurtBox : HurtBoxBoss1
var on = true

func Enter():
	if enemy.morte:
		Transitioned.emit(self, "death")
	Status.aumentar_count(1)
	enemy.playSound()
	timer = randf_range(0,1)
	on = true
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	

func Exit():
	on = false
	enemy.velocity = Vector2()

	
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
