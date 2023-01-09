extends Path

# States:
# - Patroling on path
# - Chasing player
# - Retreating back to path

export var speed := 10

onready var follow := $PathFollow
onready var mob    := $PathFollow/Mob

enum Direction { 
	FORWARD  =  1, 
	BACKWARD = -1
}

enum State {
	WAITING, 
	FOLLOWING, 
	RETURNING
}

var _state: int     = State.FOLLOWING
var _direction: int = Direction.FORWARD

func move(delta):
	follow.offset += _direction * speed * delta

func turn():
	_direction *= -1

func _follow(delta: float) -> void:
	var offset = follow.offset
	move(delta)
	
	if _direction == 1 and offset > follow.offset:
		turn()
		move(delta)
	elif _direction == -1 and offset < follow.offset:
		turn()
		move(delta)

func _wait(delta: float) -> void:
	pass

func _return(delta: float) -> void:
	pass

func _process(delta):
	match _state:
		State.WAITING:
			_wait(delta)
		State.FOLLOWING:
			_follow(delta)
		State.RETURNING:
			_return(delta)
		_:
			pass
