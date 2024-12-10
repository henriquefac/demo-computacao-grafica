extends Node2D

var playerInterface: Node2D
var player: PlayerCharacter
@onready var boss = $BossDuval/DuvalNode

func _ready() -> void:	
	AudioPlayer.play_music_scene(2)
	playerInterface = get_tree().get_first_node_in_group("PlayerMetro")
	player = playerInterface.playerNode

func _on_transition_complete() -> void:
	pass
