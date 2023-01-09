extends KinematicBody

enum States { IDLE, CHASING }

export var speed := 100.0

var _state: int = States.IDLE
var _target: Spatial = null
var _velocity  := Vector3.ZERO
var _direction := Vector3.ZERO

class PathFollower:
	
	enum States {SELECT, TURN, RETURN, TRAVERSE}
	
	var collision_radius = 0.5
	
	var _parent: Spatial
	var _point: Vector3
	var _path: Node
	var _state: int
	
	# func _init(parent: Spatial, path: Node):
	# 	assert(path.length() > 0)
	# 	_parent = parent
	# 	_path   = path
	# 	_state  = States.SELECT

	func step():
		# match _state:
		# 	States.SELECT:
		# 		_select()
		# 	States.TURN:
		# 		_turn()
		# 	States.TRAVERSE:
		# 		_traverse()
		pass
	
	func _select():
		_state = States.TURN
		_point = _path.next()
	
	func _turn():
		_state = States.TRAVERSE
		
	func _traverse():
		var p0 = _parent.global_transform.origin
		var p1 = _point
		var d: Vector3 = (p1 - p0).normalized()
		
		if distance_to_next() < collision_radius:
			_state = States.SELECT
	
	func distance_to_next():
		return _parent.global_transform.origin.distance_to(_point)

var path_follower: PathFollower

func _ready():
	$AnimationPlayer.play("Idle")
	
	# path_follower = PathFollower.new(self, $Path)

func _process(delta):
	match _state:
		States.IDLE:
			_direction = transform.basis.y
			_direction.normalized()
		States.CHASING:
			var p0 = global_transform.origin
			var p1 = _target.global_transform.origin
			var v  = (p1 - p0).normalized()
			var angle = atan2(-v.x, -v.z)
			rotation.y = lerp_angle(rotation.y, angle, 2 * delta)
			
			var target = _target.global_transform.origin
			var position = global_transform.origin
			_direction = (target - position).normalized()
			
			# target = lerp(global_transform.basis.y, _direction, delta)		 
			look_at(target, Vector3.UP)

func _physics_process(delta):
	_velocity.x = _direction.x
	_velocity.z = _direction.z
	_velocity *= speed * delta
	move_and_slide(_velocity, Vector3.UP)

func _on_SoundSensor_detected(body):
	_target = body
	_state = States.CHASING
	$AnimationPlayer.play("Run")
			
func _on_SoundSensor_lost(body):
	_target = null
	_state = States.IDLE
	_direction = Vector3.ZERO
	$AnimationPlayer.play("Idle")
