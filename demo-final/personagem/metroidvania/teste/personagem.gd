extends Node2D
# interface do player para conseguir interagir com elementos externos
var playerNode:PlayerCharacter 
var stateMachine:StateMachine
var recordeStatus:RecordeStatusEfect

var is_inside = false

@onready var start = load("res://cenas/cenario/topdown/Scenario_1.tscn") as PackedScene
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene
var transition_instance: CanvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerNode = $PersonagemNode
	stateMachine = $StateMachine
	recordeStatus = $RecordeStatusEfect
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)
	
# hurtbox
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Chamado a cada quadro. 'delta' é o tempo decorrido desde o quadro anterior
func _process(delta: float) -> void:
	if is_inside and Input.is_action_just_pressed("interagir"):
		print("Emitir")
		get_parent().emit_signal("player_in_door", true)
	
	if !Status.esta_vivo():
		transition_instance.transition()
		get_tree().change_scene_to_packed(start)
		await transition_instance.on_transition_finished

func _on_aim_lab_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		get_parent().emit_signal("player_in_enemy", true)

func _on_lockeddoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		is_inside = true

func _on_lockeddoor_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		is_inside = false

func _on_transition_complete() -> void:
	pass
