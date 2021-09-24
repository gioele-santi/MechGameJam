extends PlayerState

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	if player.is_on_floor() and abs(_parent.velocity.x) > 0.01:
		state_machine.transition_to("Move/Walk")
		return
	elif not player.is_on_floor():
		state_machine.transition_to("Move/Air") #it will auto transition to fall
		return

func enter(msg:Dictionary = {}) -> void:
	_parent.velocity = Vector2.ZERO
	player.transition_to(player.States.IDLE)
	_parent.enter()

func exit() -> void:
	_parent.exit()
