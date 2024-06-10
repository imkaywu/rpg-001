extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200
@export var PUSH = 400
@export var DIST_TO_TARGET = 4

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
@onready var hurt_box = $HurtBox
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController
@onready var animation_player = $AnimationPlayer


func _ready():
	state = _pick_random_state([IDLE, WANDER])


func _physics_process(delta):
	knockback = _move_and_slide(knockback, delta)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			_seek_player()
			
			if wander_controller.get_time_left() == 0:
				_update_state_and_wander()
		WANDER:
			_seek_player()
			
			if wander_controller.get_time_left() == 0:
				_update_state_and_wander()
			_move_towards_position(delta, wander_controller.target_position)
			
			if global_position.distance_to(wander_controller.target_position) <= DIST_TO_TARGET:
				_update_state_and_wander()
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				_move_towards_position(delta, player.global_position)
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * PUSH
	move_and_slide()


func _move_towards_position(delta, position):
	var dir = global_position.direction_to(position)
	velocity = velocity.move_toward(MAX_SPEED * dir, ACCELERATION * delta)
	animated_sprite_2d.flip_h = velocity.x < 0


func _update_state_and_wander():
	state = _pick_random_state([IDLE, WANDER])
	wander_controller.set_wander_timer(randi_range(1, 3))


func _on_hurt_box_area_entered(area):
	stats.health -= area.damage # calls the setter
	knockback = area.knockback_dir * 150
	hurt_box.create_hit_effect()
	hurt_box.start_invincibility(0.4)


func _on_stats_no_health():
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position


func _seek_player():
	if player_detection_zone.is_player_visible():
		state = CHASE


func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.front()


func _move_and_slide(motion, delta):
	var vtmp = velocity
	velocity = motion
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	motion = velocity
	velocity = vtmp
	return motion


func _on_hurt_box_invincibility_started():
	animation_player.play("start")


func _on_hurt_box_invicibility_ended():
	animation_player.play("stop")
