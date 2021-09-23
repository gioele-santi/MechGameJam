extends KinematicBody2D
class_name Mech

enum States {IDLE, WALK, RUN,  JUMP, FALL, BUMP, STAGGER, DIE, WIN, KICK}
onready var player := $AnimationPlayer
onready var fsm := $FSM
var state : int = 0

signal attack_completed

var direction := Vector2.ZERO setget set_direction

func _ready() -> void:
	player.connect("animation_finished", self, "_on_player_animation_finished")
	fsm.connect("transitioned", self, "_on_fsm_change")
	pass # Replace with function body.

func set_direction(value: Vector2) -> void:
	direction = value
	if direction.x > 0: #no equal -> keep last direction when no button is pressed
		$Sprite.set_flip_h(false)
	elif direction.x < 0:
		$Sprite.set_flip_h(true)
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
	var target_state_path := "Move/Ground/Idle" #most actions will go to ground idle
	if name == "die":
		queue_free()
		#signal for gameover (or delegate health object)
		return
	elif name == "win":
		#fsm or player should call game to finish level (or naything else)
		return #animation is only played at start of state
	elif name == "crouch":
		return #animation is only played at start of state
	elif name == "punch_1" or name == "punch_2" or name == "punch_special" or name == "kick":
		emit_signal("attack_completed") #fsm needs to know when anmation ends and it can switch state
#	elif name == "":
#		target_state_path = ""
	
	fsm.transition_to(target_state_path)

func _on_fsm_change(state_path: String) -> void:
	$StateLabel.text = fsm.state_name

#################

export (float, 0, 1.0) var friction = 0.02
export (float, 0, 1.0) var acceleration = 0.04
export (int) var speed = 800
export (int) var jump_speed = -1000
export (int) var gravity = 4000

#func _physics_process(delta):
#
#	if Input.is_action_just_pressed("jump"):
#		if is_on_floor():
#			velocity.y = jump_speed
#			self.state = JUMP
#
#	# apply gravity
#	velocity.y += gravity * delta
#	if velocity.y > 0 and not is_on_floor():
#		self.state = FALL
#
#	var dir = get_input_direction()
#
#	if state != JUMP and state != FALL:
#		if dir != 0:
#			velocity.x = lerp(velocity.x, dir * speed, acceleration)
#			self.state = RUN
#		else:
#			velocity.x = lerp(velocity.x, 0, friction)
#			self.state = SLIDE if abs(velocity.x) > 0.1 else IDLE
#	elif is_on_floor():
#		self.state = IDLE
#
#	velocity = move_and_slide(velocity, Vector2.UP)


#func get_input_direction() -> int:
#	var dir := 0
#	if Input.is_action_pressed("move_right"):
#		dir += 1
#		$Sprite.flip_h = false
#	if Input.is_action_pressed("move_left"):
#		dir -= 1
#		$Sprite.flip_h = true
#	return dir
