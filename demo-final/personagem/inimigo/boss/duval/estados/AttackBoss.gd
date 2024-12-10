extends State
class_name AtkStateBoss1

@export var enemy: duval

var animationNode: AnimationPlayer

var hurtBox : HurtBoxBoss1
var on = true

# porcesso de atacar

# randomizar escolha entre ataques
func choose_atk1_or_atk2() -> int:
	return randi() % 2 + 1

func Enter():
	if enemy.morte:
		Transitioned.emit(self, "death")
	enemy.velocity = Vector2(0,0)
	enemy.atk_on = true
	animationNode = enemy.animationPLayer
	on = true
	
	if not animationNode.is_connected("animation_finished",  transitionIdle):
		animationNode.connect("animation_finished", transitionIdle)

	
	if hurtBox == null:
		hurtBox = enemy.hurtbox
	if not hurtBox.is_connected("area_entered", transictionDamage):
		hurtBox.connect("area_entered", transictionDamage)
	

	var choosen_atk = choose_atk1_or_atk2()
	
	if choosen_atk == 1:
		animationNode.play("attack")
	else:
		animationNode.play("distance_attack")

func transitionIdle(algo):
	if algo == "attack" or algo == "distance_attack":
		Transitioned.emit(self, "idle")

func transictionDamage(area: Area2D):
	if area.is_in_group("hitboxPlayer") and area is HitBoxPlayer and on:
		enemy.getDamage(area)
		if enemy.vida <= 0:  # Verifica se a vida do inimigo chegou a zero
			Transitioned.emit(self, "death")
		else:
			Transitioned.emit(self, "damage")
	if area.is_in_group("hitBoxPlayer2") and area is HitBoxPlayer and on:
		enemy.getDamage2(area)
		if enemy.vida <= 0:  # Verifica se a vida do inimigo chegou a zero
			Transitioned.emit(self, "death")
		else:
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
	if enemy.vida <=0:
		return
