extends Area

signal full(node)

export var capacity := 4

var nuts     := 0
var active   := false

func store(nuts: int) -> int:
	if not active or nuts <= 0:
		return 0
	
	self.nuts += nuts

	if self.nuts >= capacity:
		var reject := self.nuts - capacity
		self.nuts = capacity
		emit_signal("full", self)
		return nuts - reject
	
	return nuts

func _on_Area_body_entered(_body):
	active = true

func _on_Area_body_exited(_body):
	active = false
