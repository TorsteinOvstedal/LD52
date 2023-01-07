extends Area

class_name Nut

func _ready() -> void:
	connect("body_entered", self, "on_player_entered")

func on_player_entered(player: PhysicsBody):
	if player.get_collision_layer_bit(0):
		player.pick_up_nut(self)
