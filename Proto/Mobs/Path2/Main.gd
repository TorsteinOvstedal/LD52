extends Spatial

# NPC Controller.

onready var targets = [$Sensor0, $Sensor1, $Sensor2, $Sensor3]

func _ready() -> void:	
	$NPC0.connect("at_target", self, "_on_npc_at_target")
	set_npc_target(0)

func set_npc_target(i: int) -> void:
	$NPC0.set_target(targets[i].global_transform.origin)

func _on_npc_at_target(npc: Spatial) -> void:
	var target = randi() % targets.size()
	set_npc_target(target)
