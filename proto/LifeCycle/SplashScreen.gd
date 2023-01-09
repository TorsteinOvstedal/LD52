extends Control

signal play

onready var title   := $TitleLabl
onready var guide   := $CenterContainer/GridContainer/GuideLabel
onready var playBtn := $CenterContainer/GridContainer/PlayButton

onready var _parent := get_parent()

func show() -> void:
	if not _shown:
		_parent.call_deferred("add_child", self)
		get_tree().set_deferred("paused", true)
		_shown = true

func hide() -> void:
	if _shown:
		get_tree().set_deferred("paused", false)
		_shown = false
		_parent.call_deferred("remove_child", self)

var _shown: bool 

func _ready() -> void:
	visible = true
	pause_mode = PAUSE_MODE_PROCESS
	playBtn.connect("pressed", self, "_on_playBtn_pressed")
	
	_shown = false
	_parent.call_deferred("remove_child", self)
	show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		emit_signal("play")

func _on_playBtn_pressed() -> void:
	emit_signal("play")
