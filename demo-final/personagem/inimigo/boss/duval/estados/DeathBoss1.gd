extends State
class_name DeathStateBoss

@export var enemy: duval

var animationNode: AnimationPlayer
var on = false

func Enter():
	enemy.morte = true
	on = true
	enemy.velocity = Vector2()
	enemy.is_dashing = false
	# Configura o AnimationPlayer
	if not animationNode:
		animationNode = enemy.animationPLayer
	if not animationNode.is_connected("animation_finished", on_death_animation_finished):
		animationNode.connect("animation_finished", on_death_animation_finished)

	# Toca a animação de morte
	animationNode.play("death")

	# Desativa colisões
	enemy.hitBoxArea.disabled = true

	print("Enemy has died.")

func Exit():
	on = false
	if animationNode:
		animationNode.stop()

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func on_death_animation_finished(_anim_name: String):
	if _anim_name == "death":
		queue_free_enemy()

func queue_free_enemy():
	if enemy and is_instance_valid(enemy):
		enemy.queue_free()
