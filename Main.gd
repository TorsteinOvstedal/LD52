extends Node

# Entry point of the application

# Application states

enum State {SPLASH, PLAYING, PAUSED}

var splash_screen := preload("res://proto/LifeCycle/SplashScreen.tscn").instance()
var pause_screen  := preload("res://proto/LifeCycle/PauseScreen.tscn").instance()
var game          := preload("res://Game.tscn").instance()

var _state: int

func _init() -> void:
	add_child(game)				# Always present
	add_child(splash_screen)

func _ready() -> void:
	# State management  signals
	splash_screen.connect("play",      self, "_on_play")
	pause_screen.connect( "pause",     self, "_on_pause")
	pause_screen.connect( "resume",    self, "_on_resume")
	pause_screen.connect( "quit",      self, "_on_quit")
	game.connect(         "game_over", self, "_on_game_over")
	
	splash_screen.show()
	
func _on_play() -> void:
	splash_screen.hide()
	remove_child(splash_screen)

	add_child(pause_screen)

	game.reset()

func _on_pause() -> void:
	pause_screen.pause()
	
func _on_resume() -> void:
	pause_screen.resume()
	
func _on_quit() -> void:
	get_tree().quit()
	
func _on_game_over() -> void:
	remove_child(pause_screen)
	
	add_child(splash_screen)
	splash_screen.show()
