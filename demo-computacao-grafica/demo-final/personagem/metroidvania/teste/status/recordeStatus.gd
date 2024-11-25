extends Node
class_name RecordeStatusEfect

@export var Player: PlayerCharacter  # Supondo que PlayerCharacter seja o nome da classe do jogador

var dictStatus: Dictionary = {}  # Dicionário para armazenar os status ativos
func _ready() -> void:
	Player.STATUS_ON.connect(addStatus)
	
func _process(delta: float) -> void:
	for status:StatusEfect in get_children():
		if status.toStart:
			Aply(status)
			status.Terminate.connect(Terminate)
		status.Update(delta)  # Atualiza todos os status
		
func addStatus(status: StatusEfect):
	add_child(status)
		
# Aplica os efeitos no jogador
func Aply(status: StatusEfect):
	for i in range(2):
		Player.aux[i] += status.listEfects[i]
# Remove o efeito quando o status termina
func Terminate(status: StatusEfect):
	for i in range(2):
		Player.aux[i] -= status.listEfects[i]  # Remove o efeito do jogador
	status.queue_free()  # Libera a memória do status
