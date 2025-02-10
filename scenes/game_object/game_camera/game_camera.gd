extends Camera2D

const POSITION_SMOOTHING = 20

var player = null
var target_position = Vector2.ZERO


func _ready():
	make_current()


func _process(delta):
	player = GroupsUtils.player
	
	if player:
		target_position = player.global_position
	
	# Camera follows target
	global_position = global_position.lerp(target_position, 1 - exp(-delta * POSITION_SMOOTHING))
