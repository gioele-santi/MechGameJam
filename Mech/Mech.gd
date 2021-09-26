extends KinematicBody2D
class_name Mech

enum States {IDLE, WALK, RUN, JUMP, FALL, BUMP, STAGGER, DIE, WIN, KICK, KICKCHARGE}
onready var player := $AnimationPlayer
onready var fsm := $FSM
var state : int = 0
onready var ball_spawn := $InteractiveAreas/BallSpawn

signal attack_completed

var direction := Vector2.ZERO setget set_direction

func _ready() -> void:
	player.connect("animation_finished", self, "_on_player_animation_finished")
	fsm.connect("transitioned", self, "_on_fsm_change")
	pass # Replace with function body.

func set_direction(value: Vector2) -> void:
	direction = value
	if direction.x > 0: #no equal -> keep last direction when no button is pressed
		$SpriteR.visible = true
		$SpriteL.visible = false
		$InteractiveAreas.scale.x = 1
	elif direction.x < 0:
		$SpriteR.visible = false
		$SpriteL.visible = true
		$InteractiveAreas.scale.x = -1
	pass

func transition_to(state_id: int) -> void:
	match state:
		States.RUN:
			#particle dust
			pass
	state = state_id
	
	var anim_name = ""
	match state:
		States.IDLE:
			anim_name = "idle"
		States.WALK:
			anim_name = "walk"
		States.RUN:
			anim_name = "run"
			#particle dust
		States.JUMP:
			anim_name = "jump"
		States.FALL:
			anim_name = "fall"
		States.BUMP:
			anim_name = "bump"
			#add tween
		States.STAGGER:
			anim_name = "stagger"
			#tween
		States.KICK:
			anim_name = "kick"
		States.KICKCHARGE:
			anim_name = "kick_charge"
		States.WIN:
			anim_name = "win"
			#fsm should have disabled all processing
		States.DIE:
			anim_name = "die"
			#fsm should have disabled all processing
		_: 
			anim_name = "SETUP"
	player.play(anim_name)

func _on_player_animation_finished(name: String)-> void:
	var target_state_path := "Move/Idle" #most actions will go to ground idle
	if name == "die":
		queue_free()
		#signal for gameover (or delegate health object)
		return
	elif name == "win":
		#fsm or player should call game to finish level (or naything else)
		return #animation is only played at start of state
	elif name == "crouch":
		return #animation is only played at start of state
	elif name == "punch_1" or name == "punch_2" or name == "punch_special" or name == "kick" or name == "kick_charge":
		emit_signal("attack_completed")
		return 
		 #fsm needs to know when anmation ends and it can switch state
#	elif name == "":
#		target_state_path = ""
	
	fsm.transition_to(target_state_path)

func _on_fsm_change(state_path: String) -> void:
	$StateLabel.text = fsm.state_name

func _on_Foot_body_entered(body: Node) -> void:
	if body is MechBall:
		enable_ball(body, "foot")

func _on_Head_body_entered(body: Node) -> void:
	if body is MechBall:
		enable_ball(body, "head")

func _on_Chest_body_entered(body: Node) -> void:
	if body is MechBall:
		enable_ball(body, "chest")

func _on_Area_body_exited(body: Node) -> void:
	if body is MechBall:
		body.controllable = false

func enable_ball(ball: MechBall,  mode: String) -> void:
	ball.controllable = true
	ball.hit_mode = mode
	ball.base_direction = direction.normalized()
	
