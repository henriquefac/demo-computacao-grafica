extends CharacterBody2D
class_name duval

@onready var progress_bar: ProgressBar = $BossInfo/ProgressBar

# parede esquerda
signal wallEsquerda
signal wallDireita

var vida = 50
@export var gravity := 900.0 
# ver de knockback
var vectorDirDamage: float

# sound player
var soudPlayerHit: AudioStreamPlayer2D

# flag para indicar morte
var morte: bool

# coiusas que vão girar no próprio eixo
# hitbox, area para dar dano no player
var hitbox: HitBoxBoss1
# area para inimigo levar dano
var hurtbox: HurtBoxBoss1
# area do body
var bodyArea: CollisionShape2D
# frames
var frames: AnimatedSprite2D 
# posição da hitbox
var x_value_hitbox: int
# posição da hurt box
var x_value_hurtbox: int
# posição da area body
var x_value_bodyArea: int
# posição dos frames
var x_value_frames: int




# raycast esquerdo
var esquerda: RayCast2D
# raycast direito
var direita: RayCast2D


# para parede esquerda
var LeftWall: bool = true
var RightWall: bool = true

# vai armazenar instancia do personagem
var personagem = null
var hitBoxArea: CollisionShape2D
var hurtBoxArea: CollisionShape2D

var state_machine: StateMachine
var states: Dictionary = {}

# nó de animação
var animationPLayer:AnimationPlayer = null



# Propriedades para dash
var dash_speed = 700
var dash_duration = 0.4  # Duração do dash em segundos
var is_dashing = false
var dash_dir = Vector2.ZERO

# se está pausado
var paused_: bool = false

# se está atacando
var atk_on = false

func _ready() -> void:
	morte = false
	
	soudPlayerHit = $soundDamage
	
	# hitbox
	hitbox = $HitBoxBoss1
	# hurtbox
	hurtbox = $HurtBoxBoss1
	# area 
	bodyArea = $box
	# frames
	frames = $frames
	
	# valor de x da hitbox 
	x_value_hitbox = hitbox.position.x
	# valor de x da hutrbox
	x_value_hurtbox = hurtbox.position.x
	# valor de x da area body
	x_value_bodyArea = bodyArea.position.x
	# valor de x dos frames
	x_value_frames = frames.position.x
	
	esquerda = $esquerda
	direita = $direita
	animationPLayer = $animacao
	


	
	hitBoxArea = $HitBoxBoss1/hitbox
	hurtBoxArea = $HurtBoxBoss1/hurtboxd
	
	progress_bar.max_value = vida
	progress_bar.value = vida
	progress_bar.min_value = 0
	pass

func _physics_process(delta: float) -> void:
	# gravidade, funciona só no ar 
	if !is_on_floor():
		velocity.y += gravity * delta
	# registra contato com paredes durante idle, não vai ser utilizado muito9
	checkFortWall()
	# controla quando a animação pode ser relizada
	# util para quando um estado exigir uma animação específica e contínua
	if !is_dashing and !atk_on and is_on_floor() and !morte:
		animation()
	
	# altera rotação dos frames baseado na velocidade do player no eixo x
	if velocity.x > 0:
		frames.flip_h = false
	if velocity.x < 0 :
		frames.flip_h = true
	# gira componenetes do boss para acompanhar frame 
	flip()
	
	# pausado, se for verdadeiro, não se move
	if not paused_ and not morte:
		move_and_slide()
	

# som
func playSound():
	soudPlayerHit.play()

# animação basica
func animation():
	if velocity.length() > 0:
		animationPLayer.play("follow")
	else:
		animationPLayer.play("idle")
	# se a velocidade ono eixo t não for 0, para
	if velocity.y != 0:
		animationPLayer.stop(true)
		
# gira muita coisa
func flip():
	# virar tudo nesse caralho
	# baseado na flag de frames
	if frames.flip_h:
		# virado para esquerda
		# posição original
		# mover frames
		frames.position.x = x_value_frames
		# mover body area
		bodyArea.position.x = x_value_bodyArea
		# mover hitbox
		hitbox.position.x = x_value_hitbox
		# mover hurtbox
		hurtbox.position.x = x_value_hurtbox
	else:
		# virar para direita
		# os valores originais são multiplicados por -1
		frames.position.x = -x_value_frames
		# mover body area
		bodyArea.position.x = -x_value_bodyArea
		# mover hitbox
		hitbox.position.x = -x_value_hitbox
		# mover hurtbox
		hurtbox.position.x = -x_value_hurtbox
		
# faz a chagem de paredes
func checkFortWall():
	# se raycast esquerdo estiver detectando algo
	# e a flag wall for verdadeira (ela controla se deve detectar parede esquerda)
	# a flag wallesquerda fica falsa e emit sinl que detectou parede
	if esquerda.is_colliding() and LeftWall:
		LeftWall = false
		# quando detecta esquerda, pode detectar direita
		RightWall = true
		wallEsquerda.emit()
	# Não está mais detectando parede e a flag está falsa, volta a poder detectar parede esquerda
	elif !esquerda.is_colliding() and !LeftWall:
		LeftWall = true
	
	# se detectar parede a direita e flag direita estiver verdadeira, emit sinal
	if direita.is_colliding() and RightWall:
		RightWall = false
		# pode detectar esuqerda
		LeftWall = true
		wallDireita.emit()
	# volta a detectar parede diereita quando para de detectar direita
	elif !direita.is_colliding() and !RightWall:
		RightWall = true
		
# realizar animacão de ataque
# quando realizar o ataque, personagem se move suavemente para adireção
# atual
# Propriedades para dash
#var dash_speed = 300
#var dash_duration = 0.2  # Duração do dash em segundos
#var is_dashing = false
#var dash_dir = Vector2.ZERO

# função que realiza movimento associado ao ataque
func atkMove():
	is_dashing = true
	dash_dir = Vector2(-1, 0)
	if !frames.flip_h:
		dash_dir.x = 1
	velocity = Vector2.ZERO
	
	velocity = velocity.move_toward(dash_dir.normalized() * dash_speed, 300)
# para de mover
func stopAtkMove():
	is_dashing = false
	velocity.x = 0
	
# função de comportamento de quando tomar dano
func getDamage(area: HitBoxPlayer):
	print("dano1")
	velocity = Vector2()
	velocity = area.vectorKnock()
	if randf() < 0.2:
		velocity.y = 0
		velocity.x *= 0.5
	vectorDirDamage = velocity.normalized().x
	vida -= area.dano
	checkDeath()
	progress_bar.value = vida
	


# outra função de tomar dano
func getDamage2(area: HitBoxPlayer):
	print("dano2")
	# Calcula a direção normalizada entre o inimigo (self) e o jogador
	var dir = (global_position - area.player.global_position).normalized()
	
	# Determina se o inimigo está à esquerda ou à direita da área do jogador
	if position.x < area.player.position.x:
		print("Inimigo está à esquerda da área")
	else:
		print("Inimigo está à direita da área")
	
	# Ajusta a direção para o vetor oposto e define a velocidade
	dir *= 200  # Amplia o vetor
	dir.y = -600  # Ajusta o componente vertical para um impulso
	velocity = dir  # Aplica a nova velocidade
	
	# Reduz a vida do inimigo com base no dano da área
	vida -= area.dano
	checkDeath()
	progress_bar.value = vida

func checkDeath():
	morte = vida <= 0
