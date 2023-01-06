extends KinematicBody

export var speed := 100.0

var _direction := Vector3.ZERO
var _velocity := Vector3.ZERO

func _ready():
	pass

func _process(delta):
	# Get innput
	_direction = Vector3.ZERO
	_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_direction.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	_direction = _direction.normalized()

func _physics_process(delta):
	_velocity = _direction * speed * delta
	
	move_and_slide(_velocity, Vector3.UP)
