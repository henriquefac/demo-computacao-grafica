extends Node2D
class_name QuadradoAzul
# criar um quadrado : D
var square_size = 120
var square_color = Color(0.2, 0.8, 0.9)

# função para desenhar esse negócio
func _draw() -> void:
	# defnir a posição e o tamanho
	var tamanho2 = square_size - 20
	var position1 = Vector2(-(tamanho2/2), -(tamanho2/2))
	var position2 = Vector2(-(square_size/2), -(square_size/2))
	var size = Vector2(square_size, square_size)
	var size2 = Vector2(tamanho2, tamanho2)
	draw_rect(Rect2(position2, size), Color(1,1,1))
	draw_rect(Rect2(position1, size2), square_color)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
