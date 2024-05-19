extends AnimatedSprite2D


func _ready():
	self.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
	frame = 0
	play("animate")


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		play("animate")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
