extends Spatial

class_name Level

# Temporary hack
export var last_level := false

var level_name = "LEVEL 0"

# Time to game over
export var time: int = 40

# NOTE: Required components of a level
onready var player_start: Vector3 = $PlayerStart.global_transform.origin
onready var home: Spatial = $Home
onready var nuts: Spatial = $Nuts

func _ready():
	assert(player_start != null and home != null and nuts != null)

	# print("[DEBUG] Nuts in the level: ", str(nuts.get_child_count()))
	# print("[DEBUG] Storage capacity:  ", str(home.capacity))
	pass
