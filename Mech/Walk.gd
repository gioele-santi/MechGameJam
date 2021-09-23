extends PlayerState

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	#add sensor for boost button here

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() and abs(_parent.velocity.x) < 0.01:
		state_machine.transition_to("Move/Idle")
		return
	elif not player.is_on_floor():
		state_machine.transition_to("Move/Air") #it will auto transition to falls
		return

func enter(msg:Dictionary = {}) -> void:
	player.transition_to(player.States.WALK)
	_parent.enter()

func exit() -> void:
	_parent.exit()
