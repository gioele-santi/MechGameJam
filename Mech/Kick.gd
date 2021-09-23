extends PlayerState

func physics_process(delta: float) -> void:
	_parent.physics_process(delta) # ir kick keeps parent movement

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	player.transition_to(player.States.KICK)
	player.connect("attack_completed", self, "_on_attack_completed")

func exit() -> void:
	player.disconnect("attack_completed", self, "_on_attack_completed")
	_parent.exit()

func _on_attack_completed() -> void:
	state_machine.transition_to("Move/Idle")
