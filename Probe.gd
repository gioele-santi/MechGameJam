extends Area2D
class_name Probe

enum FLIGHT_MODES { vertical, horizontal }
export (FLIGHT_MODES) var flight_mode = FLIGHT_MODES.vertical
export (float) var excursion = 200.0
export (float) var acceleration := 0.25

var min_y := 20.0
var max_y:= 490.0
var pos : Array = []
var idx = 0


func _ready() -> void:
	if flight_mode == FLIGHT_MODES.vertical:
		pos.append(Vector2(global_position.x, max(min_y, global_position.y - excursion/2)))
		pos.append(Vector2(global_position.x, min(max_y, global_position.y + excursion/2)))
	else:
		pos.append(Vector2(global_position.x - excursion/2, global_position.y))
		pos.append(Vector2(global_position.x + excursion/2, global_position.y))
	move_to_next()

func move_to_next() -> void:
	$Tween.interpolate_property(self, "global_position", global_position, pos[idx%pos.size()], 3.0, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	idx += 1
	move_to_next()

func _on_Probe_body_entered(body: Node) -> void:
	if body is Mech:
		body.take_damage()
	if body is MechBall:
		$Polygon2D.visible = false
		$Explosion.play()


func _on_Explosion_explosion_completed() -> void:
	queue_free()
