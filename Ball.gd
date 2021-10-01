extends RigidBody2D
class_name MechBall

signal out_of_reach

enum Modes {NONE, FOOT, HEAD, CHEST}
var hit_mode : int = Modes.NONE setget set_hit_mode

var mech: KinematicBody2D = null

var timer := 0.0
var pos_offset := Vector2.ZERO
export var base_strength := 200.0
var base_direction := Vector2(0,0) 

onready var trail := $Particles2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		timer = 0.0
	elif event.is_action_released("attack"):
		get_kicked(timer)

func get_kicked(time: float = 0.0) -> void:
	self.hit_mode = Modes.NONE
	var dir = get_input_direction()
	dir.x = base_direction.x
	dir.y = dir.y/3
	var strength = base_strength + time * 300.0
	apply_impulse(Vector2.ZERO, dir * strength)

func _process(delta: float) -> void:
	timer += delta
	if global_position.y < -400 or global_position.y > 600:
		emit_signal("out_of_reach")
		set_process(false)
#	print(str(linear_velocity.length()))
	trail.emitting = linear_velocity.length() > 150
	
	if hit_mode == Modes.FOOT:
		global_position = mech.global_position + pos_offset
		#rotate sprite
		#try to avoid boing through the floor

func get_input_direction() -> Vector2:
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()

func set_hit_mode(value: int) -> void:
	hit_mode = value
	timer = 0.0 #always reset to avoid keeping old values
	match hit_mode:
		Modes.FOOT:
			set_process_unhandled_input(false)
			mode = MODE_KINEMATIC
			pos_offset = global_position - mech.global_position
			base_direction = get_input_direction()
			base_direction.y = 0
		Modes.NONE:
			mode = MODE_RIGID
			set_process_unhandled_input(false)
		_ :
			mode = MODE_RIGID
			set_process_unhandled_input(true)
	
#	set_process_unhandled_input(controllable)
#	print("Ball is controllable:" + str(value))
