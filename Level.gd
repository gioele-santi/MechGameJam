extends Node2D
class_name Level

export (PackedScene) var ball_scene: PackedScene
var ball : MechBall = null
onready var mech := $Mech

onready var camera : MultiTargetCamera = $Camera2D

func _ready() -> void:
	camera.add_target(mech)
	spawn_ball()

func spawn_ball() -> void:
	if ball != null:
		camera.remove_target(ball)
		yield(get_tree().create_timer(1.0), "timeout")
		ball.queue_free()
		ball = null
		
	
	ball = ball_scene.instance()
	ball.mech = mech
	ball.connect("out_of_reach", self, "spawn_ball")
	
	add_child(ball)
	ball.global_position = mech.ball_spawn.global_position
	
	camera.add_target(ball)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
