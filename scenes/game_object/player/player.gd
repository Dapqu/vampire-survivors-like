extends CharacterBody2D
class_name Player

signal has_died

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals

var number_colliding_bodies = 0

var direction = 0

var base_speed = 0


func _ready():
	base_speed = velocity_component.max_speed
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	# Handles movement
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	# Handles animation
	if direction != Vector2.ZERO:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	# Handles sprite render direction
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	# The player is taking 1 damage per 0.5 sec as of right now, 
	# no matter how many enemy is colliding with the player
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func _on_collision_area_2d_body_entered(body):
	number_colliding_bodies += 1
	check_deal_damage()


func _on_collision_area_2d_body_exited(body):
	number_colliding_bodies -= 1


func _on_damage_interval_timer_timeout():
	check_deal_damage()


func _on_health_component_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()


func _on_health_component_died():
	has_died.emit()


# Handles gaining new ability and upgrades
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var power = current_upgrades[upgrade.id]["quantity"]
	
	if upgrade is Ability:
		abilities.add_child(upgrade.ability_controller_scene.instantiate())
	elif upgrade.id == "player_speed_10":
		velocity_component.max_speed = base_speed * pow(1.1, power)
