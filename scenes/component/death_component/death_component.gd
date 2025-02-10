extends Node2D

@onready var sprite = $"../Visuals/Sprite2D"
@onready var health_component = $"../HealthComponent"


func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_health_component_died)


# Handles death animation
func on_health_component_died():
	if !owner || not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	var entities = GroupsUtils.entities_layer
	
	get_parent().remove_child(self)
	global_position = spawn_position
	entities.add_child(self)
	
	$AnimationPlayer.play("default")
