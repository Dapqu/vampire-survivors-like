extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var is_moving = false


func _process(delta):
	# Handles movement, towards player
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	# Handles sprite render direction, facing moving direction
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


# For animation player
func set_is_moving(moving: bool):
	is_moving = moving
