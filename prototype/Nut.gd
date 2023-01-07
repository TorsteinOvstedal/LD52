extends KinematicBody

class_name Nut

var _velocity := Vector3.ZERO

func _process(delta):
	# TODO: Bounce, then rest
	_velocity.y = _velocity.y + (-18) * delta

func _physics_process(_delta):
	_velocity = move_and_slide(_velocity, Vector3.UP)

func _on_Area_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(0):
		body.pick_up_nut(self)
