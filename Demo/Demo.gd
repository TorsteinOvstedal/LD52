extends Spatial

var running := false
	
func nuts_left() -> int:
	return $Nuts.get_children().size()

func time_left() -> int:
	return int($CountDown.time_left)

func start() -> void:
	running = true
	
	# Set nuts to collect = number of nuts in the level
	$Home._nuts = 0
	$Home.capacity = nuts_left()
	
	# Initialize UI
	update_hud_carrying()
	update_hud_storage()

	# Start
	$CountDown.start()

func game_over(victory: bool) -> void:
	running = false

	# Force update HUD incase of race condition.
	update_hud_carrying()
	update_hud_storage()
	
	# Set game over screen 
	if victory:
		$UI.game_over.title("You collected enough nuts!")
		$UI.game_over.message("Press space to play again")
	else:
		$UI.game_over.title("Game Over")
		$UI.game_over.message("You failed to collect enough nuts.\nPress space to try again.")
	
	$UI.game_over.show()

# HUD

func update_hud_time() -> void:
	$UI.hud.time(time_left())

func update_hud_storage() -> void:
	$UI.hud.storage($Home.nuts(), $Home.capacity)
	
func update_hud_carrying() -> void:
	$UI.hud.carrying($Player.nuts(), $Player.capacity)

# Setup 

func _ready() -> void:	
	# Set paths for path-following mobs
	$Bee0.set_points($Path0.get_points())
	$Bee1.set_points($Path1.get_points())

	# Logic signals
	$CountDown.connect("timeout", self, "_on_countdown_timeout")

	$Home.connect("full", self, "_on_full_storage")
	$Home.connect("stored_nuts", self, "_on_stored_nuts")

	$Player.connect("collected_nut", self, "_on_collected_nut")
	$Player.connect("deposited_nuts", self, "_on_deposited_nuts")

	start()
		
	if Globals.reloads == 0:
		$UI.splash.show()
	else:
		$UI.splash.hide()

func _process(delta):
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down")  - Input.get_action_strength("up")
	$Player.move(x, z)
	
	update_hud_time()

# Signals

func _on_stored_nuts() -> void:
	update_hud_storage()

func _on_deposited_nuts() -> void:
	update_hud_carrying()

func _on_collected_nut() -> void:
	update_hud_carrying()
	
func _on_full_storage() -> void:
	game_over(true)

func _on_countdown_timeout() -> void:
	game_over(false)

# TODO: Re-think mob collision handling 

func _on_Bee0_body_entered(body):
	game_over(false)

func _on_Bee1_body_entered(body):
	game_over(false)

func _on_Area_body_entered(body):
	game_over(false)
