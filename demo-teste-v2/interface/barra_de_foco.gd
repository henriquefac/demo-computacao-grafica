extends HBoxContainer

var barra_foco: ColorRect
var barra_comprimento: float

func set_foco():
	# Converta um dos valores para float para evitar a truncagem
	barra_foco.size.x = barra_comprimento * (float(Status.vida_atual) / float(Status.vida_maxima))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	barra_foco = $foco/ColorRect  # Certifica que você pega o ColorRect corretamente
	barra_comprimento = barra_foco.size.x  # Define o tamanho total da barra de vida
	Status.connect("foco_auterado", Callable(self, "set_foco"))
	set_foco()
	Status.diminuir_vida(10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass# Atualiza a barra de vida a cada frame
