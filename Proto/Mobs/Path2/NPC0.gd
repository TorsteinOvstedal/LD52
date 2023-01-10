extends Spatial

# Moves in a straight line to its target.

signal at_target(npc)

export var treshold := 2.5
export var speed    := 0.5

func set_target(target: Vector3) -> void:
	self._target = target
	_active = true

func active() -> bool:
	return _active

var _target := Vector3.ZERO
var _active := false

func _process(delta) -> void:
	if active():
		_move(delta)

func _move(delta) -> void:
	var direction = (_target - global_transform.origin)
	var distance  = direction.length()
	
	if distance <= treshold:
		_active = false
		emit_signal("at_target", self)
		return
	
	direction = direction.normalized()
	var mod = distance * distance
	
	translate(direction * speed * mod * delta)	
