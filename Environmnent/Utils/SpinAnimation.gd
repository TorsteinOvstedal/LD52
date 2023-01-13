extends Node

export(NodePath) onready var target = get_node(target)

class_name SpinAnimation

export var speed := 1.0

func spin(delta: float) -> void:
	target.rotate(Vector3.UP, deg2rad(speed))

func _process(delta):
	spin(delta)
