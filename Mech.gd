extends KinematicBody2D
class_name Mech

enum {IDLE, SLIDE, RUN, JUMP, FALL, HURT, DEAD, CROUCH}
var state = IDLE setget set_state

export (float, 0, 1.0) var friction = 0.02
export (float, 0, 1.0) var acceleration = 0.04
export (int) var speed = 800
export (int) var jump_speed = -1000
export (int) var gravity = 4000

var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			self.state = JUMP
	
	# apply gravity
	velocity.y += gravity * delta
	if velocity.y > 0:
		self.state = FALL
	
	var dir = get_input_direction()
	
	if state != JUMP or state != FALL:
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
			self.state = SLIDE if velocity.x > 0.1 else IDLE
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			self.state = RUN
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
	

func get_input_direction() -> int:
	var dir := 0
	if Input.is_action_pressed("move_right"):
		dir += 1
		$Sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		dir -= 1
		$Sprite.flip_h = true
	return dir


func set_state(new_value) -> void:
	if new_value == state:
		return
	state = new_value
	print("State" + str(state))
	#match to set different animations
