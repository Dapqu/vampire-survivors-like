extends Node
class_name DifficultyManager

## Emitted when the arena difficulty increases, every *5* secs.
signal arena_difficulty_increased(arena_difficulty: int)

var arena_difficulty = 0


func _on_timer_timeout():
	arena_difficulty += 1
	arena_difficulty_increased.emit(arena_difficulty)
