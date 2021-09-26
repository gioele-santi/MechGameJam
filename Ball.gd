extends RigidBody2D
class_name MechBall

signal out_of_reach

var timer := 0.0
var controllable := false setget set_controllable
export var base_strength := 200.0
var base_direction := Vector2(0,0) 

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("kick"):
		timer = 0.0
	elif event.is_action_released("kick"):
		var strength = base_strength + timer * 3000.0
		var dir = get_input_direction()
		if dir.length() <= 0:
			dir = base_direction # in case of kick and no motion
		apply_impulse(Vector2.ZERO, dir * strength)
		print("Kick direction: " + str(dir) + " - strength: " + str(strength))

func _process(delta: float) -> void:
	timer += delta
	if global_position.y < -400 or global_position.y > 600:
		emit_signal("out_of_reach")
		set_process(false)

func get_input_direction() -> Vector2:
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()

func set_controllable(value: bool) -> void:
	controllable = value
	timer = 0.0 #always reset to avoid keeping old values
	set_process_unhandled_input(controllable)
#	print("Ball is controllable:" + str(value))
