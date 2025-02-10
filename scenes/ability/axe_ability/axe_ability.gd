extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var rotation_speed = 3
var base_rotation = Vector2.RIGHT


func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, rotation_speed)
	tween.tween_callback(queue_free)


# Handles animation
func tween_method(rotations: float):
	var precentage = rotations / 2
	var current_radius = precentage * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = GroupsUtils.player
	if player:
		global_position = player.global_position + (current_direction * current_radius)
