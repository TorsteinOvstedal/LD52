extends Control

signal play

onready var title   := $TitleLabl
onready var guide   := $CenterContainer/GridContainer/GuideLabel
onready var playBtn := $CenterContainer/GridContainer/PlayButton

onready var _parent := get_parent()

func show() -> void:
	if not _shown:
		get_tree().set_deferred("paused", true)
		_shown = true
		visible = true
		print("SHOW")
func hide() -> void:
	if _shown:
		get_tree().set_deferred("paused", false)
		_shown = false
		visible = false

var _shown: bool 

func _ready() -> void:
	_shown  = false
	visible = false
	pause_mode = PAUSE_MODE_PROCESS
	playBtn.connect("pressed", self, "_on_playBtn_pressed")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		emit_signal("play")

func _on_playBtn_pressed() -> void:
	emit_signal("play")
