extends Node

# Defines the level layout of the game

var levels := [
	{"path": "res://Levels/Prototypes/Level0.tscn", "scene": null, "instance": null},
	{"path": "res://Levels/Prototypes/Level1.tscn", "scene": null, "instance": null},
	{"path": "res://Levels/Prototypes/Level2.tscn", "scene": null, "instance": null}
]



# Access manager: Iterative

signal at_end

var _current_level := 0

func has_next() -> bool:
	return (_current_level + 1) < levels.size()

func next() -> Node:
	if not has_next():
		emit_signal("at_end")

	var level: Level = get_level()
	
	if has_next():
		_current_level += 1

	return level

func get_level() -> Level:
	var level = levels[_current_level]
	var instance = level["instance"]
	if instance:
		return instance
	
	return _load_level(_current_level)

func reload_level() -> Level:
	var level = levels[_current_level]
	var instance: Level = level["instance"]
	if instance:
		_free_instance(level)
	
	return _load_level(_current_level)

func _load_level(id: int) -> Level:
	if not _is_level(id):
		return null
	
	var level = levels[id]
	
	if not level["scene"]:
		_load_scene(level)
	
	if _instance_level(level):
		return level["instance"]		
	
	print("Failed to load level ", str(id))
	return null

func _is_level(id: int) -> bool:
	return id >= 0 and id < levels.size()

func _instance_level(level) -> Level:
	if not level["scene"]:
		return null

	var instance: Level = level["scene"].instance()
	if not instance:
		print("Faild to create instance: ", level["path"])
		return null
	
	level["instance"] = instance
	return instance	
	
func _load_scene(level) -> PackedScene:
	if not level["path"]:
		return null

	var scene: PackedScene = load(level["path"])
	if not scene:
		print("Failed to load packed scene: ", level["path"])
		return null
	
	level["scene"] = scene	
	return scene

func _free_instance(level) -> void:
	var instance: Level = level["instance"]
	if not instance:
		return
	
	var parent = instance.get_parent()
	if parent:
		parent.remove_child(instance)
	
	level["instance"] = null	
	instance.call_deferred("queue_free")

func _free_scene(level) -> void:
	var scene: PackedScene = level["scene"]
	if not scene:
		return
	
	scene.free()
