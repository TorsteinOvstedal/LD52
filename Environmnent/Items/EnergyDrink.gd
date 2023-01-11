extends Item

# Always allow player to pick up the energy drink

func query(player: PhysicsBody):
	_consumer = player
	$AudioStreamPlayer.play()
	drink()
	return true

# Buff properties

export var boost    := 500
export var duration := 4

func drink():
	_consumer.speed += boost
	_timer.start(duration)
	visible = false

func debuff_player() -> void:
	_consumer.speed -= boost
	queue_free()

var _timer: Timer
var _consumer: Spatial = null

func _init():
	_timer = Timer.new()
	_timer.one_shot  = true
	_timer.autostart = false
	add_child(_timer)

func _ready():
	_timer.connect("timeout", self, "_on_boost_completion")

func _on_boost_completion():
	debuff_player()
