extends Item

# Allow player to pick up the nut.

func query(player: PhysicsBody) -> bool:
	if player.pickup_nut(self):
		pickup()
		return true
	return false
	
func pickup() -> void:
	queue_free()
