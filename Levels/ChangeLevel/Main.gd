extends Spatial

onready var level: Level = null

func set_level(level) -> void:
	if self.level:
		remove_child(self.level)
	
	self.level = level
	add_child(self.level)


func _ready():
	LevelManager.connect("at_end", self, "_on_at_level_selection_end")
	
	set_level(LevelManager.next())

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	
	var key_event:= event as InputEventKey
	if key_event.is_action_pressed("pause"):	
		set_level(LevelManager.next())

func _on_at_level_selection_end():
	print("Game Over")
