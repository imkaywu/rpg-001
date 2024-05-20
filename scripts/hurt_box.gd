extends Area2D

@export var show_hitbox = true

const HitEffect = preload("res://scenes/hit_effect.tscn")


func _on_area_entered(area):
	if show_hitbox:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
