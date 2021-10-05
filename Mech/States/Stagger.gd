extends PlayerState

export (float, 1.0, 10.0) var cooldown_time = 1.0
var timer := 0.0

func enter(msg: Dictionary = {}) -> void:
	timer = 0.0
	# enable flashing animation on sprite

func exit() -> void:
	# disable flashing animation on sprite
	return

func physics_process(delta: float) -> void:
	timer += delta
	if timer >= cooldown_time:
		state_machine.transition_to("Move/Idle")
