extends Area2D
class_name HurtboxComponent

@onready var health_component = $"../HealthComponent"

var floating_text_scene = preload("res://scenes/ui/floating_text/floating_text.tscn")


func _on_area_entered(area):
	# Only execute the code if intersected with an ability, (which has HitboxComponent)
	# and self has health_component. (So we can handle taking damage)
	if (area is HitboxComponent) && health_component:
		var hitbox_compnent = area as HitboxComponent
		health_component.damage(hitbox_compnent.damage)
		
		# Spawns damage number above entity that was hit
		var floating_text = floating_text_scene.instantiate() as FloatingText
		floating_text.global_position = global_position + (Vector2.UP * 16)
		GroupsUtils.foreground_layer.add_child(floating_text)
		
		# Handles damage number formatting
		var format_string = "%0.1f"
		if round(hitbox_compnent.damage) == hitbox_compnent.damage:
			format_string = "%0.0f"
		floating_text.start(format_string % hitbox_compnent.damage)
