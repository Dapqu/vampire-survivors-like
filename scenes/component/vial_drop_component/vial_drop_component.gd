extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_chance: float = 1
@export var vial_scene: PackedScene
@onready var health_component = $"../HealthComponent"

var vial_instance = null


func _ready():
	health_component.died.connect(on_health_component_died)


func on_health_component_died():
	if (randf() <= drop_chance) && vial_scene && (owner is Node2D):
		var spawn_position = (owner as Node2D).global_position
		vial_instance = vial_scene.instantiate() as Node2D
		
		GroupsUtils.entities_layer.add_child(vial_instance)
		
		vial_instance.global_position = spawn_position
