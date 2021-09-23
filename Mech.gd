extends KinematicBody2D
class_name Mech

enum {IDLE, SLIDE, RUN, JUMP, HURT, DEAD, CROUCH}
var state = IDLE setget set_state

export var speed = 7.0
export var max_speed = 300.0
export var ground_drag = 3.0
export var gravity = 100.0

export var jump_speed = 5000.0

var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#print(velocity.y)
	velocity.y = gravity # change if adding a climb action
	var direction := get_input_direction()
	match state:
		SLIDE:
			velocity.x -= ground_drag * sign(velocity.x)
			if abs(velocity.x) <= 0:
				self.state = IDLE
				velocity.x = 0
		RUN:
			$Sprite.flip_h = direction.x < 0
			velocity += direction * speed
			velocity.x = clamp(velocity.x,-max_speed, max_speed)
			#generate dust particles when running
		JUMP:
			if is_on_floor():
				velocity.y = -jump_speed 

	#add inertia to slow down when no input
	move_and_slide(velocity, Vector2.UP)
	
	


func get_input_direction() -> Vector2:
	var direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0)
	
	if direction.length() <= 0:
		self.state = SLIDE
	else:
		self.state = RUN
	
	if Input.is_action_pressed("jump") and is_on_floor():
		self.state = JUMP
		print(velocity.y)
	
	return direction

func set_state(new_value) -> void:
	if new_value == state:
		return
	state = new_value
	print("State" + str(state))
	#match to set different animations
