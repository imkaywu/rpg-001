extends Area2D

var player = null


func is_player_visible():
	return player != null


func _on_body_entered(body):
	player = body


func _on_body_exited(body):
	player = null
