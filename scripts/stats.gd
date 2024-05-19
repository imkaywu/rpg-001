extends Node


@export var max_health = 1
@onready var health = max_health : set=set_health, get=get_health


signal no_health

func set_health(val):
	health = val
	if health <= 0:
		emit_signal("no_health")
	

func get_health():
	return health
