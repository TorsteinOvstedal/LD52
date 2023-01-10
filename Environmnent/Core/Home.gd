extends Area

class_name NutStorage

signal stored_nuts
signal full

export var capacity := 2

var _nuts := 0
var _active := false

func nuts() -> int:
	return _nuts

func store(nuts: int) -> int:
	if not _active or nuts <= 0:
		return 0
	
	_nuts += nuts
	
	if _nuts >= capacity:
		var reject := _nuts - capacity
		_nuts = capacity
		emit_signal("full")
		return nuts - reject
	else:
		emit_signal("stored_nuts")
		return nuts

func _on_Home_body_entered(_body):
	_active = true
	
	var player = _body as Player
	player.stash_nuts(self)

func _on_Home_body_exited(_body):
	_active = false
