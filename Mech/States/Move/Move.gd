extends PlayerState

export (float) var max_speed: = 300.0 
export (float) var move_speed: = 20000.0
export (float) var gravity: = 800.0
export (float) var jump_percentage = 66.6 # %
var jump_impulse = -1 * gravity * jump_percentage /100.0

var velocity: = Vector2.ZERO

func _ready() -> void:
	jump_impulse = -1 * gravity * jump_percentage /100.0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		state_machine.transition_to("Move/Air", { velocity = velocity, jump_impulse = jump_impulse })
		return
	if event.is_action_pressed("move_down"):
		state_machine.transition_to("Move/Crouch")
		return
	if event.is_action_pressed("kick") and player.is_on_floor():
		state_machine.transition_to("Attack/KickCharge") #it could become Attack/Punch if I have some reused code
		return

func physics_process(delta: float) -> void:
	#get input left-right
	var input_direction := get_input_direction()
	
	player.direction = input_direction
	
	velocity = calculate_velocity(velocity, input_direction, delta)
	velocity = player.move_and_slide(velocity, Vector2.UP) #it is a method on kimetic body

static func get_input_direction() -> Vector2:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	# Vertical is ignored (up - down are used for actions) unless I work with ladders
	return direction

func calculate_velocity(current_velocity: Vector2, move_direction: Vector2, delta: float) -> Vector2:
	var new_velocity: = current_velocity
	
	new_velocity = move_direction * delta * move_speed
	if new_velocity.length() > max_speed:
		new_velocity = new_velocity.normalized() * max_speed

	#apply manual gravity
	new_velocity.y = current_velocity.y + gravity * delta
	return new_velocity
