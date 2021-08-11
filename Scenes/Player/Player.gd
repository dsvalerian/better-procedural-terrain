extends KinematicBody

var camera
var movement_controller

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera
	movement_controller = $MovementController
	
	movement_controller.set_camera(camera)
