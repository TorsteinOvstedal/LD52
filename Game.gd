extends Spatial

signal game_over

# Game and UI management

onready var player := preload("res://Player/Player.tscn").instance()
onready var timer  := Timer.new()
onready var level: Level

var game_over := false

func _init() -> void:
	pass

func _ready() -> void:	
	player.visible = true
	call_deferred("add_child", player)

	timer.one_shot = true
	timer.autostart = false
	call_deferred("add_child", timer)


	set_level(LevelManager.next()) # Set initial level to the first level.
	# level.player_start.y = player.global_transform.origin.y

	# Game over signals
	timer.connect("timeout", self, "on_timeout")

	# UI signals
	player.connect("collected_nut", self, "on_player_collected_nut")
	player.connect("deposited_nuts", self, "on_player_deposited_nuts")
	
	LevelManager.connect("at_end", self, "on_last_level")

func _process(_delta) -> void:
	# User input
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")	
	player.move(x, z)

	# Update timer display
	$UI/Timer.text = str(int(timer.time_left))

func reset() -> void:
	player.global_transform.origin = level.player_start	
	set_level(LevelManager.get_level())

func start() -> void:
	timer.start(level.time)

func set_level(level) -> void:
	if self.level and self.level.get_parent():
		remove_child(self.level)

	self.level = level
	add_child(self.level)
	level.home.connect("full", self, "on_full_storage")
	
# Game over handlers	

func on_timeout() -> void:
	print("Game over")
	# game_over = true
	# get_tree().paused = true
	
func on_full_storage() -> void:
	print("You harvested enough nuts")
	game_over = true
	
	var next_level = LevelManager.next()
	if next_level == level:
		emit_signal("game_over")
	else:
		call_deferred("set_level", next_level)
	

# UI handlers

func on_player_collected_nut(player):
	$UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())

func on_player_deposited_nuts(home):
	$UI/NutInfo/Carrying.text = "Carrying: " + str(player.nuts())
	$UI/NutInfo/Storage.text  = "Storage:  " + str(level.home.nuts())

func on_last_level() -> void:
	print("Last levle")
