extends Node
class_name Path0


# NOTE: _points can only be accessed after the node is _ready
#       I.e. The path must be listed before nodes accessing it
#       in the scene tree.


onready var _points: Array = _consume_path(self)

func get_points() -> Array:
	return _points

static func _consume_path(path: Node) -> Array:
	var points := []
	
	for node in path.get_children():
		points.append(node.global_transform.origin)
		node.queue_free()
	
	return points
