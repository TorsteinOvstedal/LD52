extends Area
class_name PathMob

# TODO
# - Support tracing subranges of a path.
# - Support changing path at runtime.
# - Support arriving and changing task / state.

export var path_to_path: NodePath

export var start_point := 0

export var teleport_to_start := false

export var loop := false

export var tresh_hold := 1.0

export var speed := 20.0

var path: Path0
var counter: Counter
var target: Vector3

func _ready() -> void:	
	path = get_node(path_to_path)
	
	assert(path is Path0, "Invalid target %s. Required: %s." % [path.get_class(), Path0])

	var path_length := path.get_points().size()
	
	assert(start_point < path_length, "Invalid start point.")
	
	target = path.get_points()[start_point]
	if teleport_to_start:
		global_transform.origin = target

	if loop:
		counter = LoopCounter.new(path_length)
	else:
		counter = BackAndForthCounter.new(path_length)

func _process(delta: float) -> void:	
	var offset := target - global_transform.origin
	
	var at_target = offset.length() < tresh_hold # TODO: Use length_squared
	
	# Target selection
	if at_target:
		var next_point = counter.next()
		target = path.get_points()[next_point]
	
	# Move towards target
	else:
		var direction = offset.normalized()
		var velocity  = direction * speed * delta
		global_transform.origin += velocity
		
		look_at(target, Vector3.UP)
	
# Helpers

class Counter:
	
	var _max: int
	var _index := 0
	
	func set_max(_max: int) -> void:
		assert(_max > 0)
	
		if _max < _index:
			_index = int(max(0, _max - 1))
		
		self._max = _max

	func next() -> int:
		return 0

class LoopCounter extends Counter:

	func _init(_max: int) -> void:	
		self._max = _max
		
	func next() -> int:
		var count = _index
		
		_index = (_index + 1) % _max
		
		return count

class BackAndForthCounter extends Counter:
	
	var _direction := 1
	
	func _init(_max: int) -> void:	
		self._max = _max

	func next() -> int:
		var count := _index
		
		_index += _direction
	
		if _index == _max or _index == -1:
			_direction *= (-1)
			_index += _direction * int(min(2, _max))
	
		return count
