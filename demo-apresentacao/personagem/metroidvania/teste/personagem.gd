extends Node2D

var playerNode:PlayerCharacter 
var stateMachine:StateMachine
var recordeStatus:RecordeStatusEfect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerNode = $PersonagemNode
	stateMachine = $StateMachine
	recordeStatus = $RecordeStatusEfect
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Chamado a cada quadro. 'delta' é o tempo decorrido desde o quadro anterior
func _process(delta: float) -> void:
	if stateMachine.current_state.name == "damage":
		# Verifica se o StatusSlow já foi adicionado
		if not recordeStatus.has_node("SlowDmg"):  # Verifica se já existe
			var status = StatusSlow.new()  # Cria uma nova instância
			status.name = "SlowDmg"
			status.SetDuration(0.8)
			recordeStatus.add_child(status)  # Adiciona o status ao RecordeStatusEfect
