extends Spatial
class_name ProjectileBase

export var speed_m_per_s = 100
# after this distance from center of world, the projectile is automatically destroyed
var max_distance_from_center_squared = pow(2000, 2)

func get_firing_car() -> Car:
	return get_tree().current_scene.get_car_by_agent_id(get_network_master())

func _physics_process(delta):
	var previous_position = global_transform.origin
	translate_object_local(Vector3.BACK * delta * speed_m_per_s)
	if is_network_master():
		var current_position = global_transform.origin
		var space = get_world().direct_space_state
		var intersection = space.intersect_ray(
			previous_position,
			current_position,
			[self, get_firing_car()]
		)
		if intersection:
			rpc("on_hit", intersection)
		if current_position.length_squared() > max_distance_from_center_squared:
			rpc("on_hit", {})

func is_intersection(intersection: Dictionary):
	return intersection != null && intersection.size() > 0

puppetsync func on_hit(intersection: Dictionary):
	print("Projectile hit ", intersection)
	queue_free()
