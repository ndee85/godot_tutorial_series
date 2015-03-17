
extends Node2D

export var value = 1

func _ready():
	# Initialization here
	if get_owner() != null:
		get_owner().gears_total += value
		get_owner().get_node("gui/gears_total").set_text(str(get_owner().gears_total))
		
	get_node("Area2D").connect("body_enter",self,"_collect_gear")
	




func _collect_gear( body ):
	if get_node("AnimationPlayer").get_current_animation() != "collect":
		if get_owner() != null:
			get_owner().gears_collected += value
			get_owner().get_node("gui/gears_collected").set_text(str(get_owner().gears_collected))
		get_node("AnimationPlayer").play("collect")
		
		#queue_free()

