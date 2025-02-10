extends CanvasLayer

@onready var arena_time_manager = $"../ArenaTimeManager"
@onready var label = $MarginContainer/Label


func _process(delta):
	if arena_time_manager:
		# Display elapsed time on UI. (00:00)
		var time_elapsed = arena_time_manager.get_time_elapsed()
		label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(value: int):
	var seconds = value % 60
	@warning_ignore("integer_division")
	var minutes = (value / 60) % 60
	
	return "%02d:%02d" % [minutes, seconds]
