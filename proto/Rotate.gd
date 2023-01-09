extends Spatial

# UI

func set_label(a, b):
	$Label.text = "Cube angle: " + str(a) + "\nTarget angle: " + str(b)

func _ready():
	set_label("", "")

# Animation

func _process(delta):
	# Rotate cube
	var p0 = $Cube.global_transform.origin
	var p1 = $Point.global_transform.origin
	var v  = (p1 - p0).normalized()
	var angle = atan2(-v.x, -v.z)
	$Cube.rotation.y = lerp_angle($Cube.rotation.y, angle, 2 * delta)
	
	# Move point
	var velocity = Vector3.ZERO
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")	
	velocity.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity.normalized()

	$Point.global_transform.origin += velocity * delta * 10
