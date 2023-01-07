extends KinematicBody

class_name Player

signal collected_nut(player)
signal deposited_nuts(base)

export var speed     := 1000.0
export var capacity  := 2

func nuts() -> int:
	return _nuts

func pick_up_nut(nut) -> void:
	if _nuts < capacity:
		_nuts += 1
		emit_signal("collected_nut", self)
		nut.queue_free()

func stash_nuts(base) -> void:
	_nuts -= base.store(_nuts)
	emit_signal("collected_nut", self) # notify UI
	emit_signal("deposited_nuts", base)

func move(x: int, z: int) -> void:
	_direction.x = x
	_direction.z = z
	_direction   = _direction.normalized()

# DEVNOTE: Some momentum and speed-buildup would be nice

var _direction := Vector3.ZERO
var _velocity  := Vector3.ZERO
var _nuts      := 0

func _process(_delta):
	# Rotate towards direction of movement
	if _direction.length() > 0:
		look_at(global_transform.origin + _direction, Vector3.UP)

func _physics_process(delta):
	#_direction.y = -9.8 * 10
	_velocity = _direction * speed * delta
	move_and_slide(_velocity, Vector3.UP)
	
	_direction = Vector3.ZERO
