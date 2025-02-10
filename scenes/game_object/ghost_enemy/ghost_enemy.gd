extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


func _process(delta):
	# Handle movement, towards player
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	# Handle sprite direction, facing moving direction
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
