extends Spatial

const path = "res://Levels/Prototypes/Level0.tscn"

var level_instance = null

func load_level(path) -> bool:
	print("Loading: ", path)
	var level := load(path)
		
	if not level:
		print("Failed to load ", path)
		return false
	
	print("Loaded ", level, " from ", path)	
	
	var instance = level.instance()
	
	if not instance:
		print("Failed to instance ", level)
		return false
	
	print("Instanced ", instance, " from ", level)	
	
	add_child(instance)
	print("Added ", instance, " to the tree")	

	level_instance = instance

	return true

func reload() -> void:
	if level_instance:
		level_instance.get_parent().remove_child(level_instance)
		level_instance = null

	load_level(path)

func _ready():
	var timer := Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", self, "_on_time_out")
	timer.start(5)
	add_child(timer)
	
	load_level(path)

func _on_time_out() -> void:
	reload()
