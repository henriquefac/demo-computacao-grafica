extends Node

class_name StateMachine

@export var intitial_state: State

@export var enti: CharacterBody2D 

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	if intitial_state:
		intitial_state.Enter()
		current_state = intitial_state
		
func _process(delta: float) -> void:
	if current_state and is_instance_valid(enti):
		current_state.Update(delta)
	print(current_state.name)
	
func _physics_process(delta: float) -> void:
	if current_state and is_instance_valid(enti):
		current_state.Physics_Update(delta)

func on_child_transitioned(state: State, new_state_name: String):
	if state != current_state:
		return
		
	var new_state:State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state
	
	
	
