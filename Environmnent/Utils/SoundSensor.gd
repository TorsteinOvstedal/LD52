extends Area

class_name SoundSensor

signal detected(position)
signal lost(exit_position)

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body) -> void:
	emit_signal("detected", body)

func _on_body_exited(body) -> void:
	emit_signal("lost", body)
