extends CharacterBody2D

const Friction = 200


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	move_and_slide()

func _on_hurt_box_area_entered(area):
	velocity = area.knockback_dir * 100
