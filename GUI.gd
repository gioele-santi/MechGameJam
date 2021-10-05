extends Control
class_name GUI

onready var label = $VBoxContainer/Label
onready var button = $VBoxContainer/Button

signal play_pressed

func _ready() -> void:
	pass # Replace with function body.

func update_health(new_value: int) -> void:
	$VBoxContainer/HBoxContainer/TextureRect/TextureProgress.value = new_value

func gameover(message: String = "Mech Ball") -> void:
	label.text = message
	label.visible = true
	
	button.visible = true


func _on_Button_pressed() -> void:
	label.visible = false
	button.visible = false
	emit_signal("play_pressed")
