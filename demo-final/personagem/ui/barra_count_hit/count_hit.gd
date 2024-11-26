extends HBoxContainer

var barra_count: ColorRect
var barra_comprimento: float

func set_count():
	# Converta um dos valores para float para evitar a truncagem
	barra_count.size.x = barra_comprimento * (float(Status.count_atual) / float(Status.count_max))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	barra_count = $count/ColorRect  # Certifica que você pega o ColorRect corretamente
	barra_comprimento = barra_count.size.x  # Define o tamanho total da barra de vida
	Status.connect("count_alterado", Callable(self, "set_count"))
	set_count()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass# Atualiza a barra de vida a cada frame
