
extends RigidBody2D

export var player_speed = 200

var btn_right = Input.is_action_pressed("btn_right")
var btn_left = Input.is_action_pressed("btn_left")



func _ready():
	# Initalization here
	set_fixed_process(true)
	
func _fixed_process(delta):
	btn_right = Input.is_action_pressed("btn_right")
	btn_left = Input.is_action_pressed("btn_left")
	
	if btn_left:
		set_linear_velocity(Vector2(-player_speed,get_linear_velocity().y))
	elif btn_right:
		set_linear_velocity(Vector2(player_speed,get_linear_velocity().y))
	else:
		set_linear_velocity(Vector2(0,get_linear_velocity().y))


