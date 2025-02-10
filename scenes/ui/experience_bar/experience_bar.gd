extends CanvasLayer

@onready var progress_bar = $MarginContainer/ProgressBar


func _on_experience_manager_experience_updated(current_experience, target_experience):
	var experience_precentage = current_experience / target_experience
	progress_bar.value = experience_precentage
