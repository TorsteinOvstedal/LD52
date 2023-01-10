extends Spatial

# UI Labels
onready var carryingLabel = $UI/GridContainer/CarryingLabel
onready var storageLabel = $UI/GridContainer/StorageLabel
onready var timeLabel = $UI/TimeLabel
onready var statusLabel = $GameOver/CenterContainer/GridContainer/StatusLabel

func _ready() -> void:
	# Set nuts to collect to the number of nuts in the level
	$Home.capacity = $Nuts.get_children().size()
	
	$Home.connect("stored_nuts", self, "_on_stored_nuts")
	$Home.connect("full", self, "_on_full_storage")

	$Player.connect("deposited_nuts", self, "_on_deposited_nuts")
	$Player.connect("collected_nut", self, "_on_collected_nut")

	$CountDown.connect("timeout", self, "_on_countdown_timeout")
	
	set_storage_label()
	set_carrying_label()
	$CountDown.start()
	
func _process(delta):
	# User input 
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z = Input.get_action_strength("down") - Input.get_action_strength("up")

	$Player.move(x, z)
	timeLabel.text = str(int($CountDown.time_left))
# UI

func set_storage_label() -> void:
	var storage  = str($Home.nuts())
	var capacity = str($Home.capacity)
	storageLabel.text = storage + "/" + capacity
	
func set_carrying_label() -> void:
	var nuts = str($Player.nuts())
	carryingLabel.text = nuts

# Game state

func game_over(victory: bool) -> void:
	var text = ""
	if victory:
		text = "You collected enough nuts"
	else:
		text = "You failed to collect enough nuts"
	
	set_carrying_label()
	set_storage_label()

	statusLabel.text = text
	$GameOver.visible = true
	get_tree().paused = true
	
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
