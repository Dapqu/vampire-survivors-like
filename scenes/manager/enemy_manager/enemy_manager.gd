extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@onready var timer = $Timer

var player: Player = null

var base_spawn_time = 0
var enemy_table = WeightedTable.new()


func _ready():
	base_spawn_time = timer.wait_time
	enemy_table.add_item(basic_enemy_scene, 10)


func get_spawn_position():
	var spawn_position = Vector2.ZERO
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS
	
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func _on_timer_timeout():
	player = GroupsUtils.player
	
	if player:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		enemy.global_position = get_spawn_position()
		GroupsUtils.entities_layer.add_child(enemy)


# Handles spawn timer difficulty scaling
func _on_difficulty_manager_arena_difficulty_increased(arena_difficulty):
	var time_off = ((base_spawn_time * 0.1) / 12) * arena_difficulty
	time_off = min(time_off, base_spawn_time / 4)
	timer.wait_time = base_spawn_time - time_off
	
	# Starts spawning wizard_enemy
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
	elif arena_difficulty == 12:
		enemy_table.add_item(ghost_enemy_scene, 10)
