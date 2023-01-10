extends KinematicBody

# Behavior

func _physics_process(delta: float) -> void:	
	look_all_directions()
	move(delta)
	_shake_free(delta)

# Vision

export var view_offset := Vector3(0, 0, 0) 		# Offset from node origin
export var view_distance := 2.0

onready var space := get_world().direct_space_state

# Movement

export var speed := 1500.0
var veclocity := Vector3.ZERO
var direction := Vector3.FORWARD

# Stuck system

onready var last_position := global_transform.origin

var stuck_limit := 0.001
var stuck_time  := 0.0
var stuck_time_limit := 0.2

# View directions

const DIRECTIONS = [Vector3.FORWARD, Vector3.LEFT, Vector3.BACK, Vector3.RIGHT]

# Vision system

func look_ahead(position, target) -> Dictionary:
	return space.intersect_ray(position, target, [self])

func look_all_directions() -> void:
	var position := global_transform.origin + view_offset
	var target   := position + direction * view_distance
	
	if look_ahead(position, target):
		var openings := []
		for direction in DIRECTIONS:
			target = position + direction * view_distance
			if not look_ahead(position, target):
				openings.append(direction)
		
		# Select random opening
		var selected = randi() % openings.size()
		self.direction = openings[selected]

func look_right() -> void:
	var position := global_transform.origin + view_offset
	var target   := position + direction * view_distance

	if look_ahead(position, target):
		var looking := true
		# NOTE: Index of current direction
		# TODO: Refactor from direction Vector to int
		var i = DIRECTIONS.bsearch(direction)
		while looking:
			i = (i + 1) % DIRECTIONS.size()
			target = position + DIRECTIONS[i] * view_distance
			looking = not look_ahead(position, target)
		
		self.direction = DIRECTIONS[i]


func move(delta: float) -> void:
	veclocity = direction * speed * delta
	veclocity = move_and_slide(veclocity, Vector3.UP)


# Avoid getting stuck on objects...
# The raycast is a lot thinner than the moving object.
# More raycasts or an area could do the trick.
# The current resolution system feels too fragile.

func _shake_free(delta: float) -> void:
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
