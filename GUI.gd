extends Control
class_name GUI

func _ready() -> void:
	pass # Replace with function body.

func update_health(new_value: int) -> void:
	$VBoxContainer/HBoxContainer/TextureRect/TextureProgress.value = new_value
