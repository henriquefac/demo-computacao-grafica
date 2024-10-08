extends HBoxContainer

# Lista de barras
var list_bars: Array[ColorRect] = []
var bar_holder: HBoxContainer


var cor_dopamin: Color = Color(1, 0.514, 0.016)
# Função para adicionar barras à lista e à cena
func add_bars():
	while len(list_bars) < Status.dopamina_bars:
		var new_bar = ColorRect.new()  # Cria uma nova instância de ColorRect
		new_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_bar.color = cor_dopamin
		# Adiciona a barra ao contêiner visual (bar_holder)
		bar_holder.add_child(new_bar)
		
		# Armazena a barra na lista
		list_bars.append(new_bar)

# atualizar se as barras foram usadas
func atualizar():
	if Status.dopamina_bars > list_bars.size():
		add_bars()  # Adiciona mais barras se necessário
	for i in range(Status.dopamina_bars):

		if i < Status.dopamina_bar_atual:
			list_bars[i].color = cor_dopamin
		else: 
			list_bars[i].color = Color(0,0,0)

# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready() -> void:
	bar_holder = $dopamina/bar_holder  # Referência ao contêiner
	Status.connect("dopamina_auterada",  Callable(self, "atualizar"))
	add_bars()  # Adiciona as barras ao contêiner e à lista
	atualizar()

# Chamado a cada frame
func _process(delta: float) -> void:
	pass
