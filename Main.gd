extends Node

# Application states

var splash_screen := preload("res://UserInterface/SplashScreen.tscn").instance()
var pause_screen  := preload("res://UserInterface/PauseScreen.tscn").instance()
var game          := preload("res://Game.tscn").instance()

func _ready() -> void:
	splash_screen.connect("play", self, "_on_play")
	pause_screen.connect("pause", self, "_on_pause")
	pause_screen.connect("resume", self, "_on_resume")
	pause_screen.connect("quit", self, "_on_quit")
	game.connect("game_over", self, "_on_game_over")

	add_child(game)
	# game.reset()
	# game.start()

	# _show_splash_screen()
	add_child(pause_screen)
	
func _on_play() -> void:
	# _hide_splash_screen()
	# get_tree().paused = false
	
	# add_child(pause_screen)
	# game.reset()
	# game.start()
	pass

func _on_pause() -> void:
	pause_screen.pause()
	
func _on_resume() -> void:
	pause_screen.resume()

func _on_quit() -> void:
	_quit()
	
func _on_game_over() -> void:
	remove_child(pause_screen)
	
	add_child(splash_screen)
	splash_screen.show()
	

func _quit() -> void:
	get_tree().quit()

func _show_splash_screen() -> void:
	add_child(splash_screen)
	splash_screen.show()

func _hide_splash_screen() -> void:
	splash_screen.hide()
	remove_child(splash_screen)
