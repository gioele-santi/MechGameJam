extends Node2D
class_name Level

export (PackedScene) var mech_scene: PackedScene
export (PackedScene) var probe_scene: PackedScene
export (PackedScene) var ball_scene: PackedScene
var ball : MechBall = null
var mech : Mech = null

onready var gui: GUI = $CanvasLayer/GUI

onready var camera : MultiTargetCamera = $Camera2D

func _ready() -> void:
	
	setup_game()

func gameover() -> void:
	print("GAME OVER!!!")
	camera.remove_target(mech)
	mech.queue_free()
	mech = null
	#remove all elements so it can be reset
	#show GUI buttons
	pass

func setup_game(probe_count: int = 3) -> void:
	
	# create random probes
	if mech == null:
		mech = mech_scene.instance()
		add_child(mech)
		mech.global_position = $MechSpawn.global_position
		camera.add_target(mech)
		mech.connect("destroyed", self, "gameover")
		mech.connect("health_changed", gui, "update_health")
		mech.health = 100
		mech
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

