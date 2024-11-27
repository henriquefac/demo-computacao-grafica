extends Node2D

@onready var fowards: Button = $fowards as Button
@onready var backwards: Button = $backwards as Button
@onready var cenas = $cenas

@onready var start_scene = load("res://cenas/cenario/cena-inicio-star-wars/texto-de-ajuda.tscn") as PackedScene
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene

var count: int = 1
var max_cenas: int = 6

#STRINGs DAS CENAS DE TUTORIAL PARA EVITAR REPITACAO DE ARQUIVOS.
var arr_cenas = [
	"Primeira_Cena_Tutorial", "Segunda_Cena_Tutorial", "Terceira_Cena_Tutorial",
	"Quarta_Cena_Tutorial", "Quinta_Cena_Tutorial", "Sexta_Cena_Final_Tutorial"
	]

var transition_instance: CanvasLayer = null

func _ready() -> void:
	fowards.pressed.connect(on_fowards_pressed)
	backwards.pressed.connect(on_backwards_pressed)
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)
	
	cenas.set_text("{atual} / {limite}".format({"atual": count, "limite": max_cenas}))

func on_fowards_pressed() -> void:
	if fowards.get_text() == "Continuar":
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

func _process(delta: float) -> void:
	cenas.set_text("{atual} / {limite}".format({"atual": count, "limite": max_cenas}))

	if count > 1:
		fowards.position.x = 340
		fowards.set_text("Avançar")
		backwards.visible = true
		fowards.visible = true
	if count == 1:
		backwards.visible = false
	if count == 6:
		fowards.position.x = 320
		fowards.set_text("Continuar")

func _on_transition_complete() -> void:
	pass
