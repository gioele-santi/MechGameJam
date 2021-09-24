extends PlayerState

export (float, 10.0, 250.0) var start_value = 10.0 
var charge := 10.0 # minimum amount for kick
var overheat := false
var overheat_countdown := 10.0

func enter(msg: Dictionary = {}) -> void:
	charge = start_value
	overheat = false
	overheat_countdown = 10.0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("kick"):
		state_machine.transition_to("Attack/Kick", {"charge": charge})

func process(delta: float) -> void:
	charge += delta # consider adding a multiplier
	# emit signal to represent on GUI
	# if a max value is overflow, overheat and sen 
	if overheat :
		overheat = true
		overheat_countdown -= delta
		if overheat_countdown <= 0.0:
			state_machine.transition_to("Stagger")

func _on_attack_completed() -> void:
	overheat = true
