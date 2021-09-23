extends Node

class_name StateMachine

signal transitioned(state_path)

export var is_active:= true setget set_is_active
export var initial_state:= NodePath()
onready var state: State = get_node(initial_state) setget set_state
var state_name := "" #for debug

# Initialization

func _init() -> void:
	add_to_group("state_machine")

func _ready() -> void:
	yield(owner, "ready")
	is_active = true
	state.enter()

# State transition

func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return
	
	var target_state: State = get_node(target_state_path)
	if state == target_state:
		return # avoid transition to self
	
	state.exit()
	self.state = target_state
	state.enter(msg)
	emit_signal("transitioned", target_state_path)

# Processing

func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _process(delta: float) -> void:
	state.process(delta)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

# Setters

func set_is_active(value: bool) -> void:
	is_active = value
	set_process_unhandled_input(value)
	set_process(value)
	set_physics_process(value)
	state.is_active = value

func set_state(value: State) -> void:
	if state == value:
		return
	state = value
	state_name = state.name
	#print(state_name)
