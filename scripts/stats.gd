extends Node


@export var max_health = 1 : set=set_max_health
var health = max_health : set=set_health, get=get_health

signal no_health
signal health_changed(val)
signal max_health_changed(val)


func _ready():
	self.health = max_health


func set_health(val):
	health = val
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func set_max_health(val):
	max_health = val
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)


func get_health():
	return health
