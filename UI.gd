extends Control

func _process(delta: float) -> void:
	if get_tree().paused and Input.is_action_pressed("play"):
		get_tree().reload_current_scene()
		get_tree().paused = false
