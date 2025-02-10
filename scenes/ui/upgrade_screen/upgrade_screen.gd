extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container = $MarginContainer/CardContainer

#
func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.card_selected.connect(on_card_selected.bind(upgrade))


func on_card_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
