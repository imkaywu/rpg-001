extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

const EnemyDeathEffect = preload('res://scenes/enemy_death_effect.tscn')

var state = IDLE
var knockback = Vector2.ZERO

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone


func _ready():
	pass

func _physics_process(delta):
	knockback = _move_and_slide(knockback, delta)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			_seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var dir = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(MAX_SPEED * dir, ACCELERATION * delta)
			else:
				state = IDLE
			animated_sprite_2d.flip_h = velocity.x < 0
	move_and_slide()


func _on_hurt_box_area_entered(area):
	stats.health -= area.damage # calls the setter
	knockback = area.knockback_dir * 150


func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position


func _seek_player():
	if player_detection_zone.is_player_visible():
		state = CHASE


func _move_and_slide(motion, delta):
	var vtmp = velocity
	velocity = motion
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	motion = velocity
	velocity = vtmp
	return motion
