extends Spatial

onready var mob  = $Bee	
onready var mob2 = $Bee2
onready var path = $PathNodes

func _ready():
	var path = []
	for node in self.path.get_children():
		var point = node.global_transform.origin
		path.append(point)
	mob.set_points(path)
	mob2.set_points(path)
