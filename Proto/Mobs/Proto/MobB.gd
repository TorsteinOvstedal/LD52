extends KinematicBody

# State machine
# - Idle, Patroling, Searching, Chasing
# - Enter
# - Leave / Terminate

export var speed: float = 100.0

onready var vision_sensor := $VisionSensor
onready var sound_sensor  := $SoundSensor

enum State { IDLE, PATROLING, SEARCHING, CHASING, DEAD }

var _state: int = State.IDLE

var _target: Spatial = null
var _vision: RayCast = null

var _velocity  := Vector3.ZERO
var _direction := Vector3.ZERO

func set_state(state: int) -> void:
	match state:
		State.IDLE:
			_state = state
			$AnimationPlayer.play("Idle")
			
		State.SEARCHING:
			_state = state
			$AnimationPlayer.stop()
	
		State.CHASING:
			_state = state
			$AnimationPlayer.play("Run")

func _readey():
	set_state(State.IDLE)
	
func get_vision():
	for beam in vision_sensor.get_children():
		if beam.is_colliding():
			return beam
	return null
	
func _process(delta):
	_direction = Vector3.ZERO
				
	match _state:
		State.IDLE:
			pass

		State.SEARCHING:
			# var target  = _target.global_transform.origin
			# var position = global_transform.origin
			# _vision = get_vision()
			# if _vision:
			set_state(State.CHASING)
			pass
	
		State.CHASING:
			var target  = _target.global_transform.origin
			var position = global_transform.origin
		
			_direction = (target - position).normalized()
			
			look_at(target, Vector3.UP)
			
			_vision = get_vision()
			if not _vision:
				set_state(State.SEARCHING)

func _physics_process(delta):
	_velocity.x = _direction.x
	_velocity.z = _direction.z
	_velocity  *= speed * delta
	move_and_slide(_velocity, Vector3.UP)

func _on_SoundSensor_detected(body):
	_target = body
	set_state(State.SEARCHING)

func _on_SoundSensor_lost(body):
	_target = null
	set_state(State.IDLE)
