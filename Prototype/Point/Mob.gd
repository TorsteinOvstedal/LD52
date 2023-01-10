extends Area

# It would be nice to specify a subrange of a path

class Counter:
	
	var _index: int
	var _max:   int
	
	var _function:    FuncRef
	var _backward_fn: FuncRef
	var _forward_fn:  FuncRef

	func _init(_max: int) -> void:	
		_forward_fn  = funcref(self, "_forward")
		_backward_fn = funcref(self, "_backward")
		_function    = _forward_fn
		set_max(_max)
		self._index = 0

	func next() -> int:
		print(_index)
		var x = _index
		_function.call_func()
		return x
		
	func set_max(_max: int) -> void:
		if _max < _index:
			_index = _max - 1
	
		self._max = _max

	func _forward() -> void:
		_index += 1
		if _index == _max:
			_index -= min(_max, 2)
			_function = _backward_fn
		
	func _backward() -> void:
		_index -= 1
		if _index < 0:
			_index += min(_max, 2)
			_function = _forward_fn

class LoopCounter:
	
	var _index: int
	var _max:   int
	
	var _function:    FuncRef
	var _backward_fn: FuncRef
	var _forward_fn:  FuncRef

	func _init(_max: int) -> void:	
		set_max(_max)
		self._index = 0

	func set_max(_max: int) -> void:
		if _max < _index:
			_index = _max - 1
	
		self._max = _max

	func next() -> int:
		var x = _index
		_index = (_index + 1) % _max
		return x

export var loop := false
export var start := 0

var _counter

var _points := []
var _index  := 0

func set_points(points: Array) -> void:
	if not points:
		return
	
	_points = points 
	_counter.set_max(_points.size())

func set_start_point(index: int) -> void:
	if index < 0 or index >= _points.size():
		index = 0
	
	_index = index

export var speed      := 20.0
export var tresh_hold := 1

var directon := Vector3.ZERO
var velocity := Vector3.ZERO

func _ready() -> void:
	if loop:
		_counter = LoopCounter.new(0)
	else:
		_counter = Counter.new(0)

	_index = start

var at_point := false

func _process(delta: float) -> void:
	if at_point:
		_index = _counter.next()
		at_point = false
	
	var target: Vector3 = _points[_index]
	var offset := target - global_transform.origin
	
	if offset.length() > tresh_hold:
		var direction := offset.normalized()
		var velocity  := direction * speed * delta
		global_transform.origin += velocity
		
		look_at(_points[_index], Vector3.UP)
	else:
		at_point = true
