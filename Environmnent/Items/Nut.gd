extends Item

# Allow player to pick up the nut.

func query(player: PhysicsBody) -> bool:
	if player.pickup_nut(self):
		pickup()
		return true
	return false
	
func pickup() -> void:
	visible = false
	$AudioStreamPlayer.play()
	
func _ready():
	$AudioStreamPlayer.autoplay = false
	$AudioStreamPlayer.connect("finished", self, "_on_asp_finished")

func _on_asp_finished() -> void:
	queue_free()
		
