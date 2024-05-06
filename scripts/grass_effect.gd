extends Node2D


@onready var animated_sprite = $AnimatedSprite2D


func _ready():
	animated_sprite.play("fall")


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		animated_sprite.play("fall")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
