extends Node

var is_gun_firing = false
var gun_firing_period_ms = 100
var gun_last_fired_time = 0
var gun_last_fired_node_index = 0

func _physics_process(delta):
	# gun processing is here because it is very rapid, and it must not be tied
	# to fps, like _process function is
	if is_gun_firing && is_network_master():
		try_fire_gun()

func try_fire_gun():
	if is_network_master():
		var current_time = OS.get_ticks_msec()
		# if we should've fire more then 1 gun very rapidly, we reset the timer,
		# so that doesn't happen
		var ms_since_last_fire = current_time - gun_last_fired_time
		if ms_since_last_fire > gun_firing_period_ms * 1:
			gun_last_fired_time = current_time - gun_firing_period_ms
		if ms_since_last_fire >= gun_firing_period_ms:
			do_fire_gun()

func do_fire_gun():
	if is_network_master():
		gun_last_fired_time = OS.get_ticks_msec()
		if get_child_count() == 0:
			print("Car doesn't have any gun points to fire from. Please add spatial nodes as children of Guns node")
		else:
			var current_firing_gun_node_index = (gun_last_fired_node_index + 1) % get_child_count()
			var firing_child: Spatial = get_child(current_firing_gun_node_index)
			rpc("spawn_gun_bullet", firing_child.global_transform.origin, firing_child.global_transform.basis.get_euler())

puppetsync func spawn_gun_bullet(pos: Vector3, rot: Vector3):
	var bullet_scene = preload("res://cars/common/gun-bullet.tscn").instance()
	bullet_scene.translation = pos
	bullet_scene.rotation = rot
	bullet_scene.set_network_master(get_tree().get_rpc_sender_id())
	get_tree().current_scene.add_child(bullet_scene)
