extends Node
class_name HealthComponent

## Emitted when the current_health reaches 0.
signal died
## Emitted when the current_health changes.
signal health_changed

@export var max_health: float = 10
var current_health = 0


func _ready():
	current_health = max_health


func damage(value: float):
	# Preventing current_health ever goes below 0
	current_health = max(current_health - value, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health == 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
