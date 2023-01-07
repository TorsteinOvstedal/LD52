extends Spatial

onready var camera := $Camera
onready var player := $Player
onready var level  := $Level
onready var timer  := $CountDown

var game_over := false

func _ready():
	timer.connect("timeout", self, "on_timeout")
	level.home.connect("full", self, "on_full_storage")

	player.visible = true
	reset()
	start()

func _process(_delta) -> void:
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")	
	player.move(x, z)
		
	if Input.get_action_strength("deposit"):
		player.stash_nuts(level.home)
		
	$UI/Timer.text = str(int(timer.time_left))
	$UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())
	$UI/NutInfo/Storage.text  = "Storage:  " + str(level.home.nuts())

func reset() -> void:
	player.global_transform.origin = level.player_start
	timer.stop()

func start() -> void:
	timer.start(level.time)
	
func on_timeout() -> void:
	print("Game over")
	game_over = true
	get_tree().paused = true
	
func on_full_storage() -> void:
	print("Game over: You harvested enough nuts")
	game_over = true
	get_tree().paused = true
	

