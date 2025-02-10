extends CanvasLayer
class_name EndScreen

@onready var title_label = $MarginContainer/PanelContainer/ContextMargin/Context/Labels/TitleLabel
@onready var description_label = $MarginContainer/PanelContainer/ContextMargin/Context/Labels/DescriptionLabel


func _ready():
	get_tree().paused = true


func set_victory():
	title_label.text = "Victory"
	description_label.text = "You Won!"


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You Lost!"


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
