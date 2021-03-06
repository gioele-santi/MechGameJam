extends Area2D
class_name Probe

signal probe_exploded

export (float) var excursion = 200.0
export (float) var acceleration := 0.25

var min_y := 20.0
var max_y:= 490.0
var pos : Array = []
var idx = 0


func initialize(init_pos: Vector2 = Vector2.ZERO, vertical: bool = true) -> void:
	global_position = init_pos
	
	if vertical:
		pos.append(Vector2(global_position.x, max(min_y, global_position.y - excursion/2)))
		pos.append(Vector2(global_position.x, min(max_y, global_position.y + excursion/2)))
	else:
		pos.append(Vector2(global_position.x - excursion/2, global_position.y))
		pos.append(Vector2(global_position.x + excursion/2, global_position.y))
	move_to_next()

func move_to_next() -> void:
	$Tween.interpolate_property(self, "global_position", global_position, pos[idx%pos.size()], 3.0, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	$Sprite.flip_h = not $Sprite.flip_h

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	idx += 1
	move_to_next()

func _on_Probe_body_entered(body: Node) -> void:
	if body is Mech:
		body.take_damage()
	if body is MechBall:
		$AnimationPlayer.play("explosion")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("probe_exploded")
	queue_free()
