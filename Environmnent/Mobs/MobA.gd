extends KinematicBody

enum States { IDLE, CHASING }

export var speed := 100.0

var _state: int = States.IDLE
var _target: Spatial = null
var _velocity  := Vector3.ZERO
var _direction := Vector3.ZERO

func _ready():
	$AnimationPlayer.play("Idle")

func _process(delta):
	match _state:
		States.IDLE:
			pass
		States.CHASING:
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
