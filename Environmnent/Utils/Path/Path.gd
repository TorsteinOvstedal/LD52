extends Node

class_name Path0

static func _consume_path(path: Node) -> Array:
	var points := []
	
	for node in path.get_children():
		points.append(node.global_transform.origin)
		node.queue_free()
	
	return points

onready var _points: Array = _consume_path(self)

func get_points() -> Array:
	return _points
