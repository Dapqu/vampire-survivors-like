extends Node

const MAX_RANGE = 100

@export var sword_ability: PackedScene
@export var base_damage = 5

var damage = 0
var base_wait_time = 0

var player: Player = null
var enemies = null
var sword_instance: SwordAbility = null


func _ready():
	base_wait_time = $Timer.wait_time
	damage = base_damage
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout():
	player = GroupsUtils.player
	enemies = get_tree().get_nodes_in_group("enemy")
	
	if player:
		# filter emenies to keep the ones within MAX_RANGE.
		enemies = enemies.filter(func(enemy: Node2D): 
			return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		)
		
		# sort array from closest to farest.
		enemies.sort_custom(func(a: Node2D, b: Node2D):
			var a_distance = a.global_position.distance_squared_to(player.global_position)
			var b_distance = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
		)
		
		# If there is any enemy in the scene after the filter,
		# spawn the sword at the closest enemy.
		if enemies:
			sword_instance = sword_ability.instantiate() as SwordAbility
			
			sword_instance.global_position = enemies[0].global_position
			sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
			
			var enemy_direction = enemies[0].global_position.direction_to(sword_instance.global_position)
			sword_instance.rotation = enemy_direction.angle()
			
			GroupsUtils.foreground_layer.add_child(sword_instance)
			
			sword_instance.hitbox_component.damage = damage


# Handle ability upgrades
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var power = current_upgrades[upgrade.id]["quantity"]
	
	if upgrade.id == "sword_rate_10":
		var upgraded_time = base_wait_time
		upgraded_time = upgraded_time * pow(0.9, power)
		$Timer.wait_time = upgraded_time
	elif upgrade.id == "sword_damage_10":
		damage = base_damage * pow(1.1, power)
