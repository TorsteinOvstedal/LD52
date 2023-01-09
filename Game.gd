extends Spatial

# Game and UI management

onready var player := $Player				# FIXME
onready var level  := $Level				# FIXME
onready var timer  := $CountDown			# FIXME

var game_over := false

func _ready() -> void:
	# TODO: Find a better solution
	player.visible = true
	level.player_start.y = player.global_transform.origin.y

	# Game over signals
	timer.connect("timeout", self, "on_timeout")
	level.home.connect("full", self, "on_full_storage")
	# TODO: Signal for completion of last level?
	
	# UI signals
	player.connect("collected_nut", self, "on_player_collected_nut")
	player.connect("deposited_nuts", self, "on_player_deposited_nuts")

	# Start	
	reset()
	start()

func _process(_delta) -> void:
	# User input
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")	
	player.move(x, z)

	# Update timer display
	$UI/Timer.text = str(int(timer.time_left))

func reset() -> void:
	player.global_transform.origin = level.player_start

func start() -> void:
	timer.start(level.time)

# Game over handlers	

func on_timeout() -> void:
	print("Game over")
	game_over = true
	get_tree().paused = true
	
func on_full_storage() -> void:
	print("Game over: You harvested enough nuts")
	game_over = true
	get_tree().paused = true

# UI handlers

func on_player_collected_nut(player):
	$UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())

func on_player_deposited_nuts(home):
	$UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())
	$UI/NutInfo/Storage.text  = "Storage:  " + str(level.home.nuts())
