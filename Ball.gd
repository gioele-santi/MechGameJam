extends RigidBody2D
class_name MechBall

var timer := 0.0
var controllable := false setget set_controllable
export var base_strength := 200.0

func _ready() -> void:
	set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("kick"):
		timer = 0.0
		set_process(true)
	elif event.is_action_released("kick"):
		set_process(false)
		var strength = base_strength + timer * 500.0
		apply_impulse(Vector2.ZERO, get_input_direction() * strength)

func _process(delta: float) -> void:
	timer += delta

func get_input_direction() -> Vector2:
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()

#func get_thrown(direction: Vector2, stength: float = 2500.0) -> void:
#	#offset should be on point of contact
#	apply_impulse(Vector2.ZERO, direction * strength)
	

func set_controllable(value: bool) -> void:
	controllable = value
	set_process_unhandled_input(controllable)
	print("Ball is controllable:" + str(value))

# when setting controllable I need the player to send itsposition so I can guaess the direction in case of not running player (if not running I have no direction.x
