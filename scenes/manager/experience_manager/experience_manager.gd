extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const EXPERIENCE_GROWTH_FACTOR = 1.5

var current_experience = 0
var current_level = 1
var target_experience = 1


func _ready():
	experience_updated.emit(current_experience, target_experience)
	GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)


func increment_experience(number: float):
	current_experience += number
	
	if current_experience >= target_experience:
		current_level += 1
		level_up.emit(current_level)
		current_experience -= target_experience
		target_experience *= EXPERIENCE_GROWTH_FACTOR
		
	experience_updated.emit(current_experience, target_experience)


func _on_experience_vial_collected(number: float):
	increment_experience(number)
