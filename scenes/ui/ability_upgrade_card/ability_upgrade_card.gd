extends SubViewportContainer
class_name AbilityUpgradeCard

## Emitted when a upgrade card is selected.
signal card_selected

@onready var name_label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label = $SubViewport/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel
@onready var quantity_label = $SubViewport/PanelContainer/MarginContainer2/QuantityLabel

var angle_x_max: float = 15.0
var angle_y_max: float = 15.0

var tween_hover: Tween
var tween_rot: Tween

var disabled = false


func _ready():
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	# Display on card
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	quantity_label.text = str(upgrade.current_quantity) + " / " + str(upgrade.max_quantity)


func check_and_stop_tween():
	# Disable cards incase player spam MB
	disabled = true
	# Validate & kill tweens
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()


func play_discard():
	check_and_stop_tween()
	$AnimationPlayer.play("discard")


func select_card():
	# Discard all other cards
	for card in get_tree().get_nodes_in_group("upgrade_card"):
		if card == self:
			check_and_stop_tween()
			$AnimationPlayer.play("selected")
		else:
			card.play_discard()
	
	# Wait for the animation to finish before emit the unpause signal
	await $AnimationPlayer.animation_finished
	card_selected.emit()


func _on_gui_input(event):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()
	
	# Handles rotation
	var mouse_pos: Vector2 = get_local_mouse_position()
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	material.set_shader_parameter("x_rot", rot_y)
	material.set_shader_parameter("y_rot", rot_x)


func _on_mouse_entered():
	if disabled:
		return
	
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


func _on_mouse_exited():
	if disabled:
		return
	
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(material, "shader_parameter/y_rot", 0.0, 0.5)
	
	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
