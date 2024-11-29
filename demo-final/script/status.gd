extends Node

var posX_Metro = 55
var posY_Metro = 383

var posX_TD = 152
var posY_TD = 269


# emitir sinias quando algum status forem afetados
signal foco_auterado
signal dopamina_auterada
signal count_alterado

signal foco_zero

var vida_maxima = 100
var vida_atual = vida_maxima



# quantidade de barras de copamina
var dopamina_bars = 3
var dopamina_bar_atual = dopamina_bars

var count_max = 5
var count_atual = 0

# controle da camera
var zooms = 0

# Função para reduzir a vida
func diminuir_vida(dano: int):
	vida_atual = max(vida_atual - dano, 0)
	emit_signal("foco_auterado")


# Função para restaurar vida
func restaurar_vida(valor: int):
	vida_atual = min(vida_atual + valor, vida_maxima)
	emit_signal("foco_auterado")


func diminuir_dopamina(dano: int):
	dopamina_bar_atual = max(dopamina_bar_atual - dano, 0)
	emit_signal("dopamina_auterada")


# Função para restaurar vida
func restaurar_dopamina(valor: int):
	dopamina_bar_atual = min(dopamina_bar_atual + valor, dopamina_bars)
	emit_signal("dopamina_auterada")


func aumentar_count(valor: int):
	count_atual += valor
	if count_atual >= count_max:
		count_atual = 0
		restaurar_dopamina(1)
	emit_signal("count_alterado")

# Função para verificar se o personagem está vivo
func esta_vivo() -> bool:
	return vida_atual > 0
