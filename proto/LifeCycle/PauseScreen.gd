extends Control

signal pause
signal resume
signal quit

onready var resumeBtn := $CenterContainer/VBoxContainer/ResumeButton
onready var quitBtn   := $CenterContainer/VBoxContainer/QuitButton

func pause() -> void:
	visible = true
	get_tree().set_deferred("paused", true)

func resume() -> void:
	visible = false
	get_tree().set_deferred("paused", false)

func _ready() -> void:
	visible = false
	pause_mode = PAUSE_MODE_PROCESS
	resumeBtn.connect("pressed", self, "_on_resumeBtn_pressed")
	quitBtn.connect("pressed", self, "_on_quitBtn_pressed")

func _toggle_pause() -> void:
	if visible:
		emit_signal("resume")
	else:
		emit_signal("pause")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()

func _on_resumeBtn_pressed() -> void:
	_toggle_pause()

func _on_quitBtn_pressed() -> void:
	emit_signal("quit")
