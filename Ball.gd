extends RigidBody2D
class_name MechBall

export var strength := 200.0

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("kick"):
#		print("kick")
#		apply_impulse(Vector2.ZERO, get_input_direction() * strength)

func get_input_direction() -> Vector2:
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()

func get_thrown(direction: Vector2) -> void:
	#offset should be on point of contact
	apply_impulse(Vector2.ZERO, direction)
