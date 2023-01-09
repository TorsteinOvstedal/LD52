extends Node

onready var follow := $PathFollow

func _ready():
	pass

func _process(delta):
	for mob in follow.get_children():
			
