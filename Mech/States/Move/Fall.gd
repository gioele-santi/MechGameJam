extends PlayerState

var parachute_enabled = true # if true enable use

func unhandled_input(event: InputEvent) -> void:
	pass

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	if player.is_on_floor(): #should not happen while elevating
		state_machine.transition_to("Move/Idle")
		return

func enter(msg: Dictionary = {}) -> void:
	_parent.enter()
	

func exit() -> void:
	_parent.exit()
