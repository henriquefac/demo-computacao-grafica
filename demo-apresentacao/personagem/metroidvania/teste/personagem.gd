extends Node2D
# interface do player para conseguir interagir com elementos externos
var playerNode:PlayerCharacter 
var stateMachine:StateMachine
var recordeStatus:RecordeStatusEfect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerNode = $PersonagemNode
	stateMachine = $StateMachine
	recordeStatus = $RecordeStatusEfect
	
	# hurtbox
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Chamado a cada quadro. 'delta' é o tempo decorrido desde o quadro anterior
func _process(delta: float) -> void:
	pass
