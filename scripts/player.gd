extends CharacterBody2D

const Acceleration = 500
const MaxSpeed = 80
const RollSpeed = 80
const Friction = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_dir = Vector2.LEFT

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")


func _ready():
	animation_tree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	dir = dir.normalized()
	
	if dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Run/blend_position", dir)
		animation_tree.set("parameters/Attack/blend_position", dir)
		animation_tree.set("parameters/Roll/blend_position", dir)
		animation_state.travel("Run")
		velocity = velocity.move_toward(dir * MaxSpeed, Acceleration * delta)
		roll_dir = dir
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func roll_state(delta):
	velocity = RollSpeed * roll_dir
	move_and_slide()
	animation_state.travel("Roll")


func attack_state(delta):
	velocity = Vector2.ZERO # stop sliding after attack
	animation_state.travel("Attack")


func attack_animation_finished():
	state = MOVE
	

func roll_animation_finished():
	velocity = Vector2.ZERO # stop sliding after roll
	state = MOVE
