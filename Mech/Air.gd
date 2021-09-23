extends PlayerState

export (int) var max_super_jump = 1
var super_jump := 1
var impulse := 0.0 

func unhandled_input(event: InputEvent) -> void:
	#no parent actions, totally custom
	if event.is_action_pressed("jump") and super_jump > 0:
		super_jump -= 1
		apply_impulse(impulse)
		#add particles
	elif event.is_action_pressed("kick"): 
		state_machine.transition_to("Move/Kick") #it could become Attack/Punch if I have some reused code
		return

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	if _parent.velocity.y > 0.001: #must happen once
		state_machine.transition_to("Move/Fall")
		return
	
	if player.is_on_ceiling():
		_parent.velocity.y = 0
	if player.is_on_floor(): #should not happen while elevating
		state_machine.transition_to("Move/Idle")
		return

func apply_impulse(impulse: float) -> void:
	#reset value to apply same boost at every height 
	# (otherwise low height has much more energy)
	_parent.velocity.y = impulse 
	player.transition_to(player.States.JUMP)

func enter(msg: Dictionary = {}) -> void:
	#to jump, apply impulse upwards when enter
	match msg:
		{"velocity": var v, "jump_impulse": var ji}:
			_parent.velocity = v + Vector2(0, ji)
			impulse = ji
	player.transition_to(player.States.JUMP)
	super_jump = max_super_jump
	_parent.enter()

func exit() -> void:
	_parent.exit()
