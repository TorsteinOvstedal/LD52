extends Control

func reload() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	Globals.reloads += 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		# Advance from info screen
		if $Info.visible:
			$Info.visible = false
			get_tree().paused = false

		# Toggle pause
		elif get_parent().running:
			get_tree().paused = !get_tree().paused
			$PauseScreen.visible = get_tree().paused
		
		# Game over: Restart
		else:
			reload()

func show_start_display() -> void:
	pass
