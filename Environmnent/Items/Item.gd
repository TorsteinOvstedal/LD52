extends Area

# Abstract
class_name Item

# Abstract
func query(player: PhysicsBody) -> bool:
	return false

func consume() -> void:
	_active = false

var _active := true

func _ready() -> void:
	collision_layer = 0
	connect("body_entered", self, "_on_player_entered")

func _on_player_entered(player: PhysicsBody):
	if _active and query(player):
		consume()
