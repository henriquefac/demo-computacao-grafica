extends Control

@onready var resume_button: Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var return_menu_button: Button = $PanelContainer/VBoxContainer/ReturnMenuButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/QuitButton
@onready var menu = load("res://scenes/main_menu.tscn") as PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	z_index = 5
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible


func resume():
	get_tree().paused = false
	self.visible = !self.visible


func _on_resume_button_pressed() -> void:
	resume()


func _on_return_menu_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_packed(menu)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
