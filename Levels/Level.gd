extends Spatial

class_name Level

export var time: int = 40

onready var player_start: Vector3 = $PlayerStart.global_transform.origin
onready var home: Spatial = $Home
onready var nuts: Spatial = $Nuts

func _ready():
	print("[DEBUG] Nuts in the level: ", str(nuts.get_child_count()))
	print("[DEBUG] Storage capacity:  ", str(home.capacity))
