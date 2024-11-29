extends Node2D

@onready var fowards: Button = $fowards as Button
@onready var backwards: Button = $backwards as Button
@onready var close: Button = $close as Button
@onready var cenas = $cenas as Label
@onready var seta_tras = $Seta_Tras as Sprite2D

@onready var main_menu = load("res://cenas/cenario/menu/main_menu.tscn") as PackedScene
@onready var start_scene = load("res://cenas/cenario/cena-inicio-star-wars/texto-de-ajuda.tscn") as PackedScene
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene

#STRINGs DAS CENAS DE TUTORIAL PARA EVITAR REPITACAO DE ARQUIVOS.
var arr_cenas = [
	"Primeira_Cena_Tutorial", "Segunda_Cena_Tutorial", "Terceira_Cena_Tutorial",
	"Quarta_Cena_Tutorial", "Quinta_Cena_Tutorial", "Sexta_Cena_Final_Tutorial"
	]

var count: int = 1
var max_cenas: int = len(arr_cenas)

var transition_instance: CanvasLayer = null

func _ready() -> void:
	fowards.pressed.connect(on_fowards_pressed)
	backwards.pressed.connect(on_backwards_pressed)
	close.pressed.connect(on_close_pressed)
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)
	
	cenas.set_text("{atual} / {limite}".format({"atual": count, "limite": max_cenas}))

func on_fowards_pressed() -> void:
	if count == max_cenas:
		on_continuar_pressed()
	else:
		get_node(arr_cenas[count-1]).visible = false
		get_node(arr_cenas[count]).visible = true
		
		if count < max_cenas:
			count += 1

func on_backwards_pressed() -> void:
	get_node(arr_cenas[count-1]).visible = false
	get_node(arr_cenas[count-2]).visible = true
	
	if count > 1:
		count -= 1

func on_continuar_pressed() -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_packed(start_scene)

func on_close_pressed() -> void:
	transition_instance.transition()
	await transition_instance.on_transition_finished
	get_tree().change_scene_to_packed(main_menu)

func _process(delta: float) -> void:
	cenas.set_text("{atual} / {limite}".format({"atual": count, "limite": max_cenas}))

	if count > 1:
		backwards.visible = true
		seta_tras.visible = true
		fowards.visible = true
	if count == 1:
		backwards.visible = false
		seta_tras.visible = false

func _on_transition_complete() -> void:
	pass
