### todo
 #setup Statemachine
 #left/right rotation
 #doublejump



extends RigidBody2D

var input_states = preload("res://scripts/input_states.gd")

export var player_speed = 200
export var jumpforce = 2000
export var acceleration = 7
export var air_acceleration = 1
export var extra_gravity = 400

var PLAYERSTATE_PREV = ""
var PLAYERSTATE = ""
var PLAYERSTATE_NEXT = "ground"

var ORIENTATION_PREV = ""
var ORIENTATION = ""
var ORIENTATION_NEXT = "right"

var raycast_down = null

var current_speed = Vector2(0,0)

var rotate = null
var jumping = 0

var btn_right = input_states.new("btn_right")
var btn_left = input_states.new("btn_left")
var btn_jump = input_states.new("btn_jump")

var anim_player = null
var anim = ""
var anim_new = ""
var anim_speed = 1.0
var anim_blend = 0.2

func move(speed, acc, delta):
	current_speed.x = lerp(current_speed.x , speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x,get_linear_velocity().y))

func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false

func _ready():
	get_node("Camera2D").set_zoom(get_node("Camera2D").get_zoom() * get_node("/root/global").viewport_scale)

	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)
	rotate = get_node("rotate")
	
	# Initalization here
	set_fixed_process(true)
	set_applied_force(Vector2(0,extra_gravity))
	
	
	anim_player = get_node("rotate/character_sprites/AnimationPlayer")

func rotate_behavior():
	if ORIENTATION == "right" and ORIENTATION_NEXT == "left":
		rotate.set_scale(rotate.get_scale() * Vector2(-1,1))
	elif ORIENTATION == "left" and ORIENTATION_NEXT == "right":
		rotate.set_scale(rotate.get_scale() * Vector2(-1,1))
		


func _fixed_process(delta):
	
	PLAYERSTATE_PREV = PLAYERSTATE
	PLAYERSTATE = PLAYERSTATE_NEXT
	
	ORIENTATION_PREV = ORIENTATION
	ORIENTATION = ORIENTATION_NEXT
	

	if PLAYERSTATE == "ground":
		ground_state(delta)
	elif PLAYERSTATE == "air":
		air_state(delta)
		
	if anim != anim_new:
		anim_new = anim
		anim_player.play(anim,anim_blend,anim_speed)
			
func ground_state(delta):

	if btn_left.check() == 2:
		move(-player_speed, acceleration, delta)
		ORIENTATION_NEXT = "left"
		anim = "run"
		anim_speed = 2.0
		anim_blend = 0.2
	elif btn_right.check() == 2:
		move(player_speed, acceleration, delta)
		ORIENTATION_NEXT = "right"
		anim = "run"
		anim_speed = 2.0
		anim_blend = 0.2
	else:
		move(0, acceleration, delta)
		anim = "idle"
		anim_speed = .5
		anim_blend = 0.2
	
	
	
	rotate_behavior()
	
	if is_on_ground():
		if btn_jump.check() == 1:
			set_axis_velocity(Vector2(0,-jumpforce))
			jumping = 1
	else:
		PLAYERSTATE_NEXT = "air"
	

func air_state(delta):
	

	if btn_left.check() == 2:
		move(-player_speed, air_acceleration, delta)
		ORIENTATION_NEXT = "left"
	elif btn_right.check() == 2:
		move(player_speed, air_acceleration, delta)
		ORIENTATION_NEXT = "right"
	else:
		move(0, air_acceleration, delta)
	
	if btn_jump.check() == 1 and jumping == 1:
		set_axis_velocity(Vector2(0,-jumpforce))
		jumping += 1
	
	if get_linear_velocity().y > 0:
		anim = "jump_down"
		anim_speed = 1.0
	else:
		anim = "jump_up"
		anim_speed = 1.0
		anim_blend = 0.0
	
	rotate_behavior()
	if is_on_ground():
		PLAYERSTATE_NEXT = "ground"