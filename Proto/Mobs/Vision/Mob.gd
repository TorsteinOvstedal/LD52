extends Spatial

# Vision based navigation.
# The mob always turn 90 left when facing a wall.

# sequence.

var sequence := Sequence.new([
	Turn.RIGHT,
	Turn.LEFT,
	Turn.LEFT
])


onready var animationPlayer := $rev/AnimationPlayer
onready var raycast         := $RayCast

enum Direction {NORTH, EAST, SOUTH, WEST}

const DIRECTIONS = [
	Vector3(0, 0, 1),
	Vector3(1, 0, 0),
	Vector3(0, 0, -1),
	Vector3(-1, 0, 0),
]

enum Turn {LEFT = 1, RIGHT = -1}

class Sequence:
	
	var index    := 0	
	var sequence: Array
	
	func _init(sequence: Array) -> void:
		self.sequence = sequence
	
	func next() -> int:
		var direction = sequence[index]
		
		index += 1
		if index == sequence.size():
			index = 0
		
		return direction
	
export var speed      := 18.0
export var direction  := Direction.WEST
 
var turning := false
var turn := 0

func turn() -> void:
	turn = sequence.next()
	direction += turn
	if direction < 0:
		direction = DIRECTIONS.size() - 1
	elif direction >= DIRECTIONS.size():
		direction = 0

func _physics_process(delta: float) -> void:
	# Turning
	if turning:
		rotate_y(deg2rad(90*turn))
		turning = false

	# Facing a wall
	elif raycast.get_collider():
		turning = true
		turn()
	
	# Walking
	else:			
		var velocity = DIRECTIONS[direction] * speed * delta
		global_transform.origin += velocity
		animationPlayer.play("ArmatureAction001")
