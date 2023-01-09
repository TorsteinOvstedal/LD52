extends Node

class_name SpinAnimation

export var speed := 20.0

onready var _object := get_parent()

func set_object(object: Spatial):
	_object = object

func _ready():
	assert(_object is Spatial)

var _angle := 0.0

func _spin(delta: float) -> void:
	_angle = int(_angle + speed * delta) % 360
	_object.rotate_y(deg2rad(_angle))

func _process(delta):
	_spin(delta)
