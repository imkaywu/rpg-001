extends Node2D

const GrassEffect = preload("res://scenes/grass_effect.tscn")

func create_grass_effect():
	var grass_effect = GrassEffect.instantiate()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_hurt_box_area_entered(area):
	create_grass_effect()
	queue_free()
