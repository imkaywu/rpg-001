extends Area2D

const HitEffect = preload("res://scenes/hit_effect.tscn")

var invincible = false : set=_set_invincible

signal invincibility_started
signal invicibility_ended

@onready var timer = $Timer

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)


func _on_timer_timeout():
	self.invincible = false


func _on_invincibility_started():
	monitorable = false


func _on_invicibility_ended():
	monitorable = true
