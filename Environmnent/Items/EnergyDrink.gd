extends Spatial

signal consumed
signal completed

export var boost := 500
export var duration := 4

onready var timer = $Duration

var _consumed := false
var _consumer: Spatial = null

func _ready():
	timer.one_shot = true
	timer.autostart = false
	timer.connect("timeout", self, "_on_boost_completion")

func _consume():
	_consumer.speed += boost
	timer.start(duration)
	visible = false
	emit_signal("consumed")

func _on_EnergyDrink_body_entered(body):
	if not _consumed:
		_consumer = body
		_consume()
		_consumed = true

func _on_EnergyDrink_body_exited(body):
	pass

func _on_boost_completion():
	_consumer.speed -= boost
	emit_signal("completed")
	queue_free()
