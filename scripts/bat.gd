extends CharacterBody2D

const Friction = 200

@onready var stats = $Stats


func _ready():
	pass

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	move_and_slide()

func _on_hurt_box_area_entered(area):
	stats.health -= area.damage # calls the setter
	velocity = area.knockback_dir * 100


func _on_stats_no_health():
	queue_free()
