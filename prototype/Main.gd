extends Node

onready var player  := $Player
onready var storage := $Base
onready var timer   := $CountDown

var game_over := false

func _process(_delta):
	if game_over:
		player.move(0, 0) # FIXME
		return
	
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")	
	player.move(x, z)
		
	if storage.active and Input.get_action_strength("deposit"):
		player.stash_nuts(storage)

	$UI/Time.text = str(int(timer.time_left))

func _on_CountDown_timeout():
	print("Game Over")
	game_over = true

func _on_Base_full(node):
	print("You collected all nuts in time.")
	game_over = true
