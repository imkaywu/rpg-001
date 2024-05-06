extends Node2D


func create_grass_effect():
	const GRASS_EFFECT = preload("res://scenes/grass_effect.tscn")
	var grass_effect = GRASS_EFFECT.instantiate()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_hurt_box_area_entered(area):
	create_grass_effect()
	queue_free()
