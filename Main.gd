extends Node

# Application states

var splash_screen := preload("res://UserInterface/SplashScreen.tscn").instance()
var pause_screen  := preload("res://UserInterface/PauseScreen.tscn").instance()
var game          := preload("res://Game.tscn").instance()

func _ready() -> void:
	# splash_screen.connect("play", self, "_on_play")
	pause_screen.connect("pause", self, "_on_pause")
	pause_screen.connect("resume", self, "_on_resume")
	pause_screen.connect("quit", self, "_on_quit")
	game.connect("game_over", self, "_on_game_over")

	add_child(game)
	add_child(pause_screen)

func _quit() -> void:
	get_tree().quit()

func _on_pause() -> void:
	pause_screen.pause()
	
func _on_resume() -> void:
	pause_screen.resume()

func _on_quit() -> void:
	_quit()
	
func _on_game_over() -> void:
	_quit()

