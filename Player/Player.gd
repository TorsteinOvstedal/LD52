extends KinematicBody

class_name Player

signal collected_nut(player)
signal deposited_nuts(base)

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
		emit_signal("collected_nut", self)
		return true

	return false

func drink_energy_drink(drink) -> bool:
	speed += drink.boost
	return true


# Deposits as many nuts as possible at the base
func stash_nuts(base) -> void:
	_nuts -= base.store(_nuts)
	emit_signal("collected_nut", self) 		# notify UI
	emit_signal("deposited_nuts", base)

# Moves the player in the given direction
func move(x: int, z: int) -> void:
	_direction.x = x
	_direction.z = z
	_direction   = _direction.normalized()
	
	# Play run animation if moving
	if _direction.length() != 0:
		$Ekorn/AnimationPlayer.play("ArmatureAction")
	else:
		$Ekorn/AnimationPlayer.stop(true)

# TODO: Some momentum / speed-buildup 

var _direction := Vector3.ZERO
var _velocity  := Vector3.ZERO
var _nuts      := 0

# TODO: Smooth animation

func _process(_delta):	
	# Rotate towards direction of movement
	if _direction.length() > 0:
		look_at(global_transform.origin + _direction, Vector3.UP)
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.stop()

func _physics_process(delta):
	_velocity = _direction * speed * delta
	move_and_slide(_velocity, Vector3.UP)
	_direction = Vector3.ZERO
