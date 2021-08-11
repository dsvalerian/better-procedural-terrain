extends Node

var mouse_sensitivity = .01
var movement_speed = 10
var gravity = 20
var jump_velocity = 10

var rotation_x
var rotation_y

var camera
	
func _ready():
	reset_mouse()
	
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		camera.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		
func set_camera(p_camera):
	camera = p_camera

func reset_mouse():
	rotation_x = 0.0
	rotation_y = 0.0
