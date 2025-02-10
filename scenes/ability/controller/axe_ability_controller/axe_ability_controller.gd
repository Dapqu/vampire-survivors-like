extends Node

@export var axe_ability: PackedScene
@export var base_damage = 10
@export var base_count = 1

var damage = 0
var count = 0

var player: Player = null
var axe_instance: AxeAbility = null

func _ready():
	# Setup references for upgrades later on
	damage = base_damage
	count = base_count
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout():
	player = GroupsUtils.player
	
	if player:
		for i in count:
			axe_instance = axe_ability.instantiate() as AxeAbility
			axe_instance.global_position = player.global_position
			GroupsUtils.foreground_layer.add_child(axe_instance)
			axe_instance.hitbox_component.damage = damage


# Handle ability upgrades
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var power = current_upgrades[upgrade.id]["quantity"]
	
	if upgrade.id == "axe_damage_10":
		damage = base_damage * pow(1.1, power)
	elif upgrade.id == "axe_count_1":
		count += 1
