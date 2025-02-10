extends Node

@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var ability_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage_10.tres")
var upgrade_axe_count = preload("res://resources/upgrades/axe_count_1.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate_10.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage_10.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed_10.tres")

func _ready():
	upgrade_pool.add_item(ability_axe, 1)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 2)


# Preventing certain ability being chosen without the prerequisite ability
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == ability_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 5)
		upgrade_pool.add_item(upgrade_axe_count, 2)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	upgrade.current_quantity = current_upgrades[upgrade.id]["quantity"]
	print(current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity >= upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	# Display 3(max) abilities on screen for choices
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func _on_experience_manager_level_up(new_level):
	var chosen_upgrades = pick_upgrades()
	
	if chosen_upgrades.size() > 0:
		var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
		upgrade_screen_instance.upgrade_selected.connect(on_upgrade_seleccted)


func on_upgrade_seleccted(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
