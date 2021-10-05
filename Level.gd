extends Node2D
class_name Level

export (PackedScene) var mech_scene: PackedScene
export (PackedScene) var probe_scene: PackedScene
export (PackedScene) var ball_scene: PackedScene
var ball : MechBall = null
var mech : Mech = null

onready var gui: GUI = $CanvasLayer/GUI
onready var camera : MultiTargetCamera = $Camera2D

var level := 1
var probe_count := 0

func _ready() -> void:
	randomize()

func gameover(message: String = "Game Over") -> void:
	print("GAME OVER!!!")
	camera.remove_target(mech)
	mech.queue_free()
	mech = null
	for c in $Probes.get_children():
		c.queue_free()
	probe_count = 0
	level = 1
	$CanvasLayer/GUI.gameover(message)

func setup_game() -> void:
	
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
	spawn_probes(3)
	spawn_ball()

func spawn_probes(count: int = 1) -> void:
	for i in range(0, count):
		var probe = probe_scene.instance()
		probe_count += 1
		probe.connect("probe_exploded", self, "_probe_exploded")
		$Probes.add_child(probe)
		var x = randi() % 1580 + 300
		var y = randi() % 300 + 150
		var vertical = ((x + y) % 2 == 0)
		probe.initialize(Vector2(x,y), vertical)
		
	pass

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

func _probe_exploded() -> void:
	probe_count -= 1
	if probe_count == 0:
		if level < 10:
			level += 1
			spawn_probes(level + 2)
		if level >= 10:
			gameover("You win!")
	pass


func _on_GUI_play_pressed() -> void:
	setup_game()
