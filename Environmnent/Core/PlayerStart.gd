extends Spatial

func _ready():
	$MeshInstance.queue_free()
	hide()
