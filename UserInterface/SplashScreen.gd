extends Control

signal play

onready var title   := $TitleLabl
onready var guide   := $CenterContainer/GridContainer/GuideLabel
onready var playBtn := $CenterContainer/GridContainer/PlayButton

func show() -> void:
	if not _shown:
		visible = true
		_shown = true
		get_tree().paused = true

func hide() -> void:
	if _shown:
		visible = false
		_shown = false
		get_tree().paused = false

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
