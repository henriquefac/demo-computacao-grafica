extends MatrizRandoWalk
class_name Wall

var cells = preload("res://testes/matriz/celula.tscn")

var bolas:Node2D 
var esquerda:Node2D
var direita:Node2D
# ajusta a distância entre quadrados
const DISTANCIA_ENTRE_QUADRADOS: int = 60
# posicão inicial
const firstPosition:Vector2 = Vector2(-105, 70) 

var matrizCelulas:Array[Array] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GenRandonWalks()
	bolas = $RotationCircles
	esquerda = $RotationCircles/left
	direita = $RotationCircles/right
	genCells()
	
	# começo
	var postionFirst = cords[0]
	direita.position = matrizCelulas[postionFirst.x][postionFirst.y].position
	# segundo
	var postionSecond = cords[1]
	matrizCelulas[postionSecond.x][postionSecond.y].Enable()
	
func genCells():
		#gerar quadrados
	for i in range(altura):
		matrizCelulas.append([])
		for j in range(largura):
			matrizCelulas[i].append(cells.instantiate())
			matrizCelulas[i][j].position = firstPosition + Vector2(j, i) * DISTANCIA_ENTRE_QUADRADOS 
			add_child(matrizCelulas[i][j])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rotation_circles_troca() -> void:
	if len(cords) > 0:
		var qdr = cords.pop_front()
		matrizCelulas[qdr.x][qdr.y].Terminate()
		
		qdr = cords[0]
		matrizCelulas[qdr.x][qdr.y].Disable()
		if len(cords) > 1:
			qdr = cords[1]
			matrizCelulas[qdr.x][qdr.y].Enable()
			
	if esquerda.orbit_speed < 6:
		var dif = 3/esquerda.orbit_speed 
		esquerda.orbit_speed += 0.2 * dif
		direita.orbit_speed -= 0.2 * dif
