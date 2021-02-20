extends VehicleBody
class_name Car

export var engine_power = 3000
export var brake_power = 50
puppet var input_engine_power = 0
puppet var input_brake_power = 0
puppet var input_steering = 0

func _physics_process(delta):
	self.engine_force = input_engine_power * engine_power
	self.brake = input_brake_power * brake_power
	self.steering = lerp_angle(self.steering, deg2rad(45) * input_steering, 0.12)

func _process(_delta):
	if is_network_master():
		rset_unreliable("input_engine_power", input_engine_power)
		rset_unreliable("input_brake_power", input_brake_power)
		rset_unreliable("input_steering", input_steering)
		rpc_unreliable("apply_transform_from_master", transform)

puppet func apply_transform_from_master(new_transform: Transform):
	transform = new_transform
