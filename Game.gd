extends Spatial

signal game_over

# Game and UI management

onready var player := preload("res://Player/Player.tscn").instance()
onready var timer  := Timer.new()
onready var level: Level

var game_over := false
var level_completed := false

func _init() -> void:
	pass

func _ready() -> void:	
	player.visible = true
	add_child(player)

	timer.one_shot = true
	timer.autostart = false
	add_child(timer)

	call_deferred("change_level")

	# Game over signals
	timer.connect("timeout", self, "on_timeout")

	# UI signals
	player.connect("collected_nut", self, "on_player_collected_nut")
	player.connect("deposited_nuts", self, "on_player_deposited_nuts")


func _process(_delta) -> void:
	if level_completed:
		if level.last_level:
			game_over = true
		else:
			change_level()
	
	if game_over:
		emit_signal("game_over")
		return
	
	# User input
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")	
	player.move(x, z)

	# Update timer display
	$UI/Timer.text = str(int(timer.time_left))

# UI handlers

func on_player_collected_nut(player):
	pass # $UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())

func on_player_deposited_nuts(home):
	pass # $UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())
	# $UI/NutInfo/Storage.text  = "Storage:  " + str(level.home.nuts())

# Game state

func change_level() -> void:
	var level = LevelManager.next_level()
	if level:
		add_child(level)
		level.home.connect("full", self, "on_full_storage")
	else:
		print("Game over: you colleted all the nuts you need for winter")

func reset() -> void:
	player.global_transform.origin = level.player_start
	# load / reload level

func start() -> void:
	timer.start(level.time)

# Game over handlers	

func on_timeout() -> void:
	print("Game over")

func on_full_storage() -> void:
	print("Level completed")
	# level_completed()

