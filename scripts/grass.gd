extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		const GRASS_EFFECT = preload("res://scenes/grass_effect.tscn")
		var grass_effect = GRASS_EFFECT.instantiate()
		var world = get_tree().current_scene
		world.add_child(grass_effect)
		grass_effect.global_position = global_position
		queue_free()
