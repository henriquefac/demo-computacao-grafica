extends State
class_name AtkState

@export var enemy: macaco

var animationNode: AnimationPlayer

var hurtBox : HurtBoxEnemy
var on = true

func Enter():
	enemy.atk_on = true
	animationNode = enemy.animationPLayer
	on = true
	
	if not animationNode.is_connected("animation_finished",  transitionIdle):
		animationNode.connect("animation_finished", transitionIdle)

	
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	
	
	enemy.velocity = Vector2()
	enemy.is_dashing = true
	animationNode.play("ataque")

func transitionIdle(algo):
	
	if algo == "ataque":
		Transitioned.emit(self, "idle")

func transictionDamage(area: Area2D):
	if area.is_in_group("hitboxPlayer") and area is HitBoxPlayer and on:
		print("damage:atk")
		enemy.getDamage(area)
		Transitioned.emit(self, "damage")
	if area.is_in_group("hitBoxPlayer2") and area is HitBoxPlayer and on:
		print("damage:atk")
		enemy.getDamage2(area)
		Transitioned.emit(self, "damage")


func Exit():
	on = false
	animationNode.stop()
	enemy.atk_on = false
	enemy.is_dashing = false
	enemy.hitBoxArea.disabled = true

func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
