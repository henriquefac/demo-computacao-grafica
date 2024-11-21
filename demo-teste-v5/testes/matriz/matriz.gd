extends Node2D
class_name MatrizRandoWalk

# matriz
var matriz: Array = []

@export var medida:=8

var altura := medida
var largura := medida - 2

var cords: Array[Vector2] = []
var initialCord: Vector2

var countTopBotton := 0
var countLeftRight := 0


func _ready() -> void:
	GenRandonWalks()
	
# Called when the node enters the scene tree for the first time.
func GenRandonWalks() -> void:
	countLeftRight = 0
	countTopBotton = 0
	# gera matriz inicial
	Gen()
	#visulizar matriz
	var string = ""
	for i in range(altura):
		for j in range(largura):
			string += str(matriz[i][j]) + ", "
		string += "\n"
	print(string)
	# percorrer matriz
	Walk()
	print(cords)
	
func RandonCord():
	var y = randi() % largura  # Coluna aleatória
	var x = randi() % altura   # Linha aleatória
	return Vector2(x, y)  # Retorna como um vetor 2D

func getNeighbor(co: Vector2):
	var neighbors = []
	if co.x + 1 < altura and matriz[co.x + 1][co.y] < 5:
		neighbors.append(Vector2(co.x + 1, co.y))
	if co.x - 1 >= 0 and matriz[co.x - 1][co.y] < 5:
		neighbors.append(Vector2(co.x - 1, co.y))
	if co.y + 1 < largura and matriz[co.x][co.y  + 1] < 5:
		neighbors.append(Vector2(co.x, co.y + 1))
	if co.y - 1 >= 0 and matriz[co.x][co.y  - 1] < 5:
		neighbors.append(Vector2(co.x, co.y - 1))
	return neighbors

func Update(neighbors: Array):
	for cord in neighbors:
		matriz[cord.x][cord.y] -= 1

func isValid(co: Vector2):
	if co.x == 0 or co.x == altura -1:
		if co.y + 1 < largura and co.y - 1 > -1:
			print(co)
			if matriz[co.x][co.y - 1] < 5 and  matriz[co.x][co.y + 1] < 5:
				countLeftRight += 1
				print(countLeftRight)
				return countLeftRight >= 2
	if co.y == 0 or co.y == largura -1:
		
		if co.x + 1 < altura and co.x - 1 > -1: 
			if matriz[co.x - 1][co.y] < 5 and  matriz[co.x + 1][co.y] < 5:
				countTopBotton += 1
				print(countTopBotton)
				return countTopBotton >= 2

func Walk():
	# quando começa, escolhe uma co
	initialCord = RandonCord()
	matriz[initialCord.x][initialCord.y] = 5
	# adiciona como coordenada inicial
	cords.append(initialCord)
	# vizinhos cordenadas
	var neighbors = getNeighbor(initialCord)
	

	# atualizar vizinhança
	Update(neighbors)
	while len(neighbors) > 0:
		
		var min = Vector2()
		var val = 10
		

		for neighbor in neighbors:

			if matriz[neighbor.x][neighbor.y] == 2 and isValid(neighbor):
				continue
			elif matriz[neighbor.x][neighbor.y] < val:
				min = neighbor
				val = matriz[neighbor.x][neighbor.y]


				
		cords.append(min)
		matriz[min.x][min.y] = 5
		neighbors = getNeighbor(min)
		if min == Vector2(7, 1):
			print(neighbors)	
		Update(neighbors)

	

func Gen():
	# matriz preenchida com valor 4
	for i in range(altura):
		matriz.append([])
		for j in range(largura):
			matriz[i].append(4)

	# Modificando as bordas
	setMatriz(0, largura - 1, 0, 0, -1)           # Linha superior
	setMatriz(0, largura - 1, altura - 1, altura - 1, -1) # Linha inferior
	setMatriz(0, 0, 0, altura - 1, -1)           # Coluna esquerda
	setMatriz(largura - 1, largura - 1, 0, altura - 1, -1) # Coluna direita

func setMatriz(col1: int, col2: int, lin1: int, lin2: int, val: int):
	for i in range(lin1, lin2 + 1):
		for j in range(col1, col2 + 1):
			matriz[i][j] += val
