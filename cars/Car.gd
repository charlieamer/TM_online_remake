extends VehicleBody
class_name Car

export var engine_power = 5000
export var brake_power = 50
# when speed is greater then this number, engine will stop applying power
# car can still go above this speed (if it goes downhill for example)
export var max_speed = 30

puppet var input_engine_power = 0
puppet var input_brake_power = 0
puppet var input_steering = 0
var input_gun_firing = false

var required_speed_for_reverse = 0.1
var max_steering_angle = 35
var steering_speed = 0.12

func _physics_process(delta):
	var relative_speed = self.linear_velocity.dot(self.global_transform.basis.z)
	# Acceleration
	if input_engine_power > 0 && relative_speed < max_speed:
		self.engine_force = input_engine_power * engine_power *  range_lerp(relative_speed / max_speed, 0, 1, 0.5, 1.0)
	else:
		self.engine_force = 0
			
	# Braking
	if self.input_brake_power > 0:
		if relative_speed < required_speed_for_reverse:
			self.engine_force = -input_brake_power * engine_power * 0.4
			self.brake = 0
		else:
			self.engine_force = 0
			self.brake = input_brake_power * brake_power
	else:
		self.brake = 0

	# Steering
	var skid_speed = self.linear_velocity.dot(self.global_transform.basis.x)
	var target_angle = max_steering_angle * input_steering
	var skid_speed_limit = range_lerp(abs(relative_speed), 0, max_speed, 5, 0.5)
	if abs(skid_speed) > skid_speed_limit:
		target_angle = range_lerp(abs(skid_speed), skid_speed_limit, 5, max_steering_angle, 10)
		target_angle = max(target_angle, -20)
		target_angle *= -sign(skid_speed)
	self.steering = lerp_angle(self.steering, deg2rad(target_angle), steering_speed)

func _process(_delta):
	if is_network_master():
		rset_unreliable("input_engine_power", input_engine_power)
		rset_unreliable("input_brake_power", input_brake_power)
		rset_unreliable("input_steering", input_steering)
		rpc_unreliable("apply_transform_from_master", transform)
		$Guns.is_gun_firing = input_gun_firing

puppet func apply_transform_from_master(new_transform: Transform):
	transform = new_transform
