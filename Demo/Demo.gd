extends Spatial

# In game
onready var carryingLabel := $UI/GridContainer/CarryingLabel
onready var storageLabel  := $UI/GridContainer/StorageLabel
onready var timeLabel     := $UI/TimeLabel

# Game over screen
onready var statusLabel := $GameOver/CenterContainer/GridContainer/StatusLabel
onready var titleLabel  := $GameOver/CenterContainer/GridContainer/TitleLabel

var running := false

# Path utility. TODO: Move into its own script.
func consume_path(path: Node) -> Array:
	var points = []
	
	for node in path.get_children():
		points.append(node.global_transform.origin)
	
	path.queue_free()
	
	return points

# Game state
	
func nuts_left() -> int:
	return $Nuts.get_children().size()

func time_left() -> int:
	return int($CountDown.time_left)

func start() -> void:
	# Set nuts to collect = number of nuts in the level
	
	$Home._nuts = 0
	$Home.capacity = nuts_left()
	
	# Initialize UI
	
	set_storage_label()
	set_carrying_label()

	# Start

	running = true
	$CountDown.start()

func game_over(victory: bool) -> void:
	running = false

	# Force update incase of bug.
	set_carrying_label()
	set_storage_label()
	
	
	if victory:
		titleLabel.text  = "You collected enough nuts!"
		statusLabel.text = "Press space to play again"
	else:
		titleLabel.text  = "Game Over"
		statusLabel.text = "You failed to collect enough nuts.\nPress space to try again."
	
	# Pause the simulation and show game over UI
	
	$GameOver.visible = true
	get_tree().paused = true

# UI

func set_timer_Label() -> void:
	timeLabel.text = str(time_left())

func set_storage_label() -> void:
	var storage  = str($Home.nuts())
	var capacity = str($Home.capacity)
	storageLabel.text = storage + "/" + capacity
	
func set_carrying_label() -> void:
	var nuts = str($Player.nuts())
	var capacity = str($Player.capacity)
	carryingLabel.text = nuts + "/" + capacity

func _ready() -> void:	
	# Set paths for path-following mobs
	
	var path0 := consume_path($Path0)
	var path1 := consume_path($Path1)
	
	$Bee0.set_points(path0)
	$Bee1.set_points(path1)

	# Logic signals
		
	$Home.connect("stored_nuts", self, "_on_stored_nuts")
	$Home.connect("full",        self, "_on_full_storage")

	$Player.connect("deposited_nuts", self, "_on_deposited_nuts")
	$Player.connect("collected_nut",  self, "_on_collected_nut")

	$CountDown.connect("timeout", self, "_on_countdown_timeout")
	
	start()
	
	# Freeze at start and display info
	
	if Globals.reloads == 0:
		get_tree().paused = true
		$UI/Info.visible = true
	else:
		$UI/Info.visible = false

func _process(delta):

	# User input 

	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down")  - Input.get_action_strength("up")
	$Player.move(x, z)
	
	# UI

	set_timer_Label()
	
func _on_stored_nuts() -> void:
	set_storage_label()
	
func _on_full_storage() -> void:
	game_over(true)

func _on_deposited_nuts() -> void:
	set_carrying_label()

func _on_collected_nut() -> void:
	set_carrying_label()
	
func _on_countdown_timeout() -> void:
	game_over(false)

# Ouuuf

func _on_Bee0_body_entered(body):
	game_over(false)

func _on_Bee1_body_entered(body):
	game_over(false)


func _on_Area_body_entered(body):
	game_over(false)
