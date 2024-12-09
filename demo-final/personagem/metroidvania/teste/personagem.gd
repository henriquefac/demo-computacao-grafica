extends Node2D

# interface do player para conseguir interagir com elementos externos
var playerNode:PlayerCharacter
var stateMachine:StateMachine
var recordeStatus:RecordeStatusEfect

signal game_paused

var is_inside = false
var paused_Monkey: bool = false

@onready var start = load("res://cenas/cenario/topdown/Scenario_1.tscn") as PackedScene
@onready var erros: ColorRect = $PersonagemNode/main_ui/Control/Erro
@onready var erros_text: Label = $PersonagemNode/main_ui/Control/Erro/Label
@onready var transition = load("res://cenas/cenario/special-effects/transition.tscn") as PackedScene
var transition_instance: CanvasLayer = null

# Inicialização
func _ready() -> void:
	playerNode = $PersonagemNode
	stateMachine = $StateMachine
	recordeStatus = $RecordeStatusEfect
	
	transition_instance = transition.instantiate() as CanvasLayer
	add_child(transition_instance)
	transition_instance.on_transition_finished.connect(_on_transition_complete)
	
	erros.visible = false
	
	self.connect("game_paused", Callable(self, "_on_paused_pressed"))
	
	#DESCOMENTE ISSO PARA SALVAR A POSICAO DO JOGADOR
	#playerNode.global_position.x = Status.posX_Metro
	#playerNode.global_position.y = Status.posY_Metro

# Chamado a cada quadro
func _physics_process (delta: float) -> void:
	#DESCOMENTE ISSO PARA SALVAR A POSICAO DO JOGADOR
	#Status.posX_Metro = playerNode.global_position.x
	#Status.posY_Metro = playerNode.global_position.y
	
	if is_inside and Input.is_action_just_pressed("interagir"):
		get_parent().emit_signal("player_in_door", true)

	if !Status.esta_vivo():
		transition_instance.transition()
		get_tree().change_scene_to_packed(start)
		await transition_instance.on_transition_finished

func _on_paused_pressed(paused_: bool):
	paused_Monkey = !paused_Monkey
	if paused_:
		get_parent().emit_signal("game_paused", paused_Monkey)

func _on_lockeddoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		is_inside = true

func _on_lockeddoor_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		is_inside = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerMetro"):
		get_parent().emit_signal("player_in_the_end", true)

func _on_transition_complete() -> void:
	pass
