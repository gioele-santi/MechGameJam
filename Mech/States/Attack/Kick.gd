extends PlayerState

func physics_process(delta: float) -> void:
	pass

func enter(msg: Dictionary = {}) -> void:
	player.transition_to(player.States.KICK)
	player.connect("attack_completed", self, "_on_attack_completed")

func exit() -> void:
	player.disconnect("attack_completed", self, "_on_attack_completed")

func _on_attack_completed() -> void:
	#emit a signal from player to throw tha ball (if in touch)
	state_machine.transition_to("Move/Idle")
