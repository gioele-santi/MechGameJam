extends State
class_name PlayerState
var player: Mech

func _ready() -> void:
	yield(owner, "ready")
	player = owner
