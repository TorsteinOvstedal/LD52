extends Control

class Hud:

	var _time:     Label
	var _carrying: Label
	var _storage:  Label

	func _init(time: Label, carrying: Label, storage: Label) -> void:
		_time     = time
		_carrying = carrying
		_storage  = storage
	
	func time(time_left: int) -> void:
		_time.text = str(time_left)

	func carrying(nuts: int, _max: int) -> void:
		_carrying.text = str(nuts) + "/" + str(_max)
		
	func storage(nuts: int, _max: int) -> void:
		_storage.text = str(nuts) + "/" + str(_max)

class Overlay:
	
	var root: Control
	
	func _init(root: Control) -> void:
		self.root = root
		self.root.visible = false
		
	func is_shown() -> bool:
		return root.visible
	
	func show() -> void:
		root.visible = true
		root.get_tree().paused = true

	func hide() -> void:
		root.visible = false
		root.get_tree().paused = false

	func toggle() -> void:
		root.get_tree().paused = !root.get_tree().paused
		root.visible = root.get_tree().paused

class GameOverScreen:

	var _title: Label
	var _message: Label
	var _overlay: Overlay
	
	func _init(root: Control, title: Label, message: Label):
		_overlay = Overlay.new(root)
		_title   = title
		_message = message

	func title(txt: String) -> void:
		_title.text = txt
		
	func message(txt: String) -> void:
		_message.text = txt
	
	func hide() -> void:
		_overlay.hide()

	func show() -> void:
		_overlay.show()
	
	func toggle() -> void:
		_overlay.toggle()


onready var hud := Hud.new(
	$HUD/Time, 
	$HUD/GridContainer/Carrying, 
	$HUD/GridContainer/Storage
)

onready var splash := Overlay.new($SplashScreen)
onready var pause := Overlay.new($PauseScreen)

onready var game_over := GameOverScreen.new(
	$GameOverScreen,
	$GameOverScreen/CenterContainer/GridContainer/Title,
	$GameOverScreen/CenterContainer/GridContainer/Status
)

onready var _game := get_parent()

func reload() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	Globals.reloads += 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		if splash.is_shown():
			splash.hide()
		elif _game.running:
			pause.toggle()		
		else:
			reload()
