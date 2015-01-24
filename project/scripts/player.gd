
extends RigidBody2D

var input_states = preload("res://scripts/input_states.gd")

export var player_speed = 200
export var jumpforce = 2000
export var acceleration = 5
export var extra_gravity = 400

var raycast_down = null

var current_speed = Vector2(0,0)

var btn_right = input_states.new("btn_right")
var btn_left = input_states.new("btn_left")
var btn_jump = input_states.new("btn_jump")

func move(speed, acc, delta):
	current_speed.x = lerp(current_speed.x , speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x,get_linear_velocity().y))

func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false

func _ready():
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)

	# Initalization here
	set_fixed_process(true)
	set_applied_force(Vector2(0,extra_gravity))
	
func _fixed_process(delta):
	
	if btn_left.check() == 2:
		move(-player_speed, acceleration, delta)
	elif btn_right.check() == 2:
		move(player_speed, acceleration, delta)
	else:
		move(0, acceleration, delta)
	
	if is_on_ground():
		if btn_jump.check() == 1:
			set_axis_velocity(Vector2(0,-jumpforce))
		

