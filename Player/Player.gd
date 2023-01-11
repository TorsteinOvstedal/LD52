extends KinematicBody

class_name Player

signal collected_nut()
signal deposited_nuts()

onready var asp0 := $RunAudioPlayer
var asp0_timestamp := 0.0

# Movement speed
export var speed := 1000.0

# Nut carry capacity
export var capacity := 2

# Returns the number of nuts the player is carrying
func nuts() -> int:
	return _nuts

# Collects a new nut 
func pickup_nut(nut) -> bool:
	if _nuts < capacity:
		_nuts += 1
		emit_signal("collected_nut")
		return true

	return false

func drink_energy_drink(drink) -> bool:
	speed += drink.boost
	return true


# Deposits as many nuts as possible at the base
func stash_nuts(base) -> void:
	_nuts -= base.store(_nuts)
	emit_signal("collected_nut")
	emit_signal("deposited_nuts")

# Moves the player in the given direction
func move(x: int, z: int) -> void:
	_direction.x = x
	_direction.z = z
	_direction   = _direction.normalized()
	
	# Play run animation if moving
	if _direction.length_squared() != 0:
		look_at(global_transform.origin + _direction, Vector3.UP)
		$Model/AnimationPlayer.play("ArmatureAction")
		play_walk_sound()
	else:
		$Model/AnimationPlayer.stop(true)
		stop_walk_sound()

func play_walk_sound() -> void:
	if not asp0.playing:
		asp0.play(asp0_timestamp)

func stop_walk_sound() -> void:
	if asp0.playing:
		asp0_timestamp = asp0.get_playback_position()
		if asp0_timestamp <= asp0.stream.get_length():
			asp0_timestamp = 0.0

		asp0.stop()
		
func play_death_sound() -> void:
	$DeathAudioPlayer.play()


# TODO: Some momentum / speed-buildup 

var _direction := Vector3.ZERO
var _velocity  := Vector3.ZERO
var _nuts      := 0

# TODO: Smooth animation

func _process(_delta):	
	if _direction.length_squared() > 0:
		look_at(global_transform.origin + _direction, Vector3.UP)

func _physics_process(delta):
	_velocity = _direction * speed * delta
	_velocity.y -= 9.8 * 50 * delta
	_velocity = move_and_slide(_velocity, Vector3.UP)		
	_direction = Vector3.ZERO
