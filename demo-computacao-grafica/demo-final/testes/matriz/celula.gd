extends Node2D
class_name Celula

# Definir o tamanho e a cor do quadrado
var areaColision: CollisionShape2D
var square_size = 60
var animation: AnimationPlayer
@export var square_color = Color(49/255.0, 41/255.0, 42/255.0)  # Definindo a cor corretamente com valores entre 0 e 1
@export var color2 = Color(90/255.0,84/255.0,85/255.0)
var radius = 25
# Função para desenhar o quadrado
func _draw() -> void:
	# Desenhar o quadrado com a cor desejada
	draw_rect(Rect2(Vector2(-square_size/2, -square_size/2), Vector2(square_size, square_size)), square_color)
	draw_circle(Vector2(0, 0), radius, color2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = $AnimationPlayer
	areaColision = $Area2D/CollisionShape2D
	
# Atualiza a visualização quando o nó entra na árvore de cena.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func Terminate():
	animation.play("terminate")

func Enable():
	areaColision.disabled = false
	animation.play("animacao")

func Disable():
	areaColision.disabled = true
	animation.play_backwards("animacao")
