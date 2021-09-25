extends PlayerState

#this has combo mgmt, I can remove it if unused

var registered_combo : int = 0
var next_combo: String = "" #name of next state in combo chain

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and registered_combo < 2:
		registered_combo += 1
		return

func physics_process(delta: float) -> void:
	#_parent.physics_process(delta)
	# no parent, I need 
	return

func enter(msg: Dictionary = {}) -> void:
	#must get a signal from player to know the punch animation was completed
	registered_combo = 0
	next_combo = ""
	match msg:
		{"combo_count": var rg}:
			registered_combo = rg
	player.connect("attack_completed", self, "_on_attack_completed")

func exit() -> void:
	player.disconnect("attack_completed", self, "_on_attack_completed") #not sure it is necessary

func _on_attack_completed() -> void:
	#check combo and decide next state
	if registered_combo > 0 and not next_combo == "":
		state_machine.transition_to(next_combo, {"combo_count": registered_combo - 1})
	else:
		state_machine.transition_to("Move/Idle")
