extends Area

class_name Nut

export var rotation_speed = 10

var r := 0

func _ready() -> void:
	connect("body_entered", self, "on_player_entered")

func on_player_entered(player: PhysicsBody):
	if player.get_collision_layer_bit(0):
		player.pick_up_nut(self)

func _process(delta):
	$MeshInstance.rotate_y(deg2rad(r))
	r = int(r + rotation_speed * delta) % 360
