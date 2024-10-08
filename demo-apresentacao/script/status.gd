extends Node
# emitir sinia s quando algum status forem afetados
signal foco_auterado
signal dopamina_auterada

var vida_maxima = 100
var vida_atual = vida_maxima

# quantidade de barras de copamina
var dopamina_bars = 3
var dopamina_bar_atual = dopamina_bars
# Função para reduzir a vida
func diminuir_vida(dano: int):
	vida_atual = max(vida_atual - dano, 0)
	emit_signal("foco_auterado")
	print("Vida atual: ", vida_atual)

# Função para restaurar vida
func restaurar_vida(valor: int):
	vida_atual = min(vida_atual + valor, vida_maxima)
	emit_signal("foco_auterado")
	print("Vida atual: ", vida_atual)

func diminuir_dopamina(dano: int):
	dopamina_bar_atual = max(dopamina_bar_atual - dano, 0)
	emit_signal("dopamina_auterada")
	print("dopamina atual: ", dopamina_bar_atual)

# Função para restaurar vida
func restaurar_dopamina(valor: int):
	dopamina_bar_atual = min(dopamina_bar_atual + valor, dopamina_bars)
	emit_signal("dopamina_auterada")
	print("dopamina atual: ", dopamina_bar_atual)

# Função para verificar se o personagem está vivo
func esta_vivo() -> bool:
	return vida_atual > 0
