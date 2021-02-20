extends "res://cars/Car.gd"

func _physics_process(delta):
	if is_network_master():
		self.input_engine_power = Input.get_action_strength("Accelerate")
		self.input_brake_power = Input.get_action_strength("Brake")
		self.input_steering = Input.get_action_strength("SteerLeft") - Input.get_action_strength("SteerRight")


func _ready():
	if is_network_master():
		var camera = self.find_node("ClippedCamera") as ClippedCamera
		if camera:
			camera.make_current()
		else:
			print("COULDN'T FIND CAMERA NODE")
