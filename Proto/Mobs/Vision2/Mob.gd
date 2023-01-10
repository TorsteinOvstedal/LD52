extends KinematicBody

export var sensor_height := 0.5
export var sensor_length := 2.0
export var speed := 1500.0

var veclocity := Vector3.ZERO
var direction := Vector3.FORWARD

const DIRECTIONS = [Vector3.FORWARD, Vector3.LEFT, Vector3.BACK, Vector3.RIGHT]

onready var last_position := global_transform.origin

func look():
	# Look ahead for blocking objects
	var position := global_transform.origin
	position.y   += sensor_height

	var target := position + direction * sensor_length
	
	var space  := get_world().direct_space_state
	
	var result  = space.intersect_ray(position, target, [self])
	
	if result:
		# Consider all directions
		var openings := []
		for direction in DIRECTIONS:
			target = position + direction * sensor_length
			if not space.intersect_ray(position, target, [self]):
				openings.append(direction)
		
		# Select random opening
		var selected = randi() % openings.size()
		self.direction = openings[selected]

func move(delta: float) -> void:
	veclocity = direction * speed * delta
	veclocity = move_and_slide(veclocity, Vector3.UP)

var stuck_limit := 0.001
var stuck_time  := 0.0
var stuck_time_limit := 0.25
	
func _physics_process(delta: float):	
	look()
	move(delta)

	# Avoid getting stuck on objects...
	# The raycast is a lot thinner than the moving object.
	# More raycasts or an area could do the trick.
	# The current resolution system feels too fragile. 

	var movement := (global_transform.origin - last_position).length()

	if movement < stuck_limit and (stuck_time >= stuck_time_limit):
		print("stuck!?")
		var old_direction = direction
		while old_direction == direction:
			var selection = randi() % DIRECTIONS.size()
			direction = DIRECTIONS[selection]	

		stuck_time = 0.0

	elif movement < stuck_limit:
		stuck_time += delta
	
	else:
		stuck_time = 0.0

	last_position = global_transform.origin
