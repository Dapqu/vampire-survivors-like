extends Node
class_name ArenaTimeManager

## Emitted when the timer reaches 0.
signal time_completed

@onready var timer = $Timer


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func _on_timer_timeout():
	time_completed.emit()
