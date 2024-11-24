extends Node
class_name StatusEfect

signal Terminate

var duration:= 0.2
var toStart := true
var listEfects: Array = [0, 0]  # Inicializando com valores padrão para velocidade e pulo

func SetDuration(dur):
	duration = dur

func _ready() -> void:
	Ready()

func Update(_delta):
	toStart = false
	
		
	
	duration -= _delta
	
	if duration <= 0:
		Terminate.emit(self)

# Funções que afetam como o player se comporta
func Remove():
	return

# Afeta velocidade
func Velocidade(speed):
	listEfects[0] = speed

# Afeta pulo
func Jump(jump):
	listEfects[1] = jump

# Inicializa os efeitos, sobrescrito por subclasses
func Ready():
	pass
