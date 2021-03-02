extends Spatial
class_name Level

# these are initialized from Menu
var my_car_name: String
var ai_car_names: Array

var is_level_initialized = false

func _ready():
	G.level_locally_ready()

func initialize_level():
	for id in G.player_agents:
		spawn_car(G.player_agents[id])

func _process(_delta):
	if get_tree().is_network_server() && !is_level_initialized && G.is_everyone_ready():
		initialize_level()
		is_level_initialized = true

var min_clearenece_at_spawn = 2
func get_available_spawn_point() -> Spatial:
	var children = $SpawnPoints.get_children()
	randomize()
	children.shuffle()
	for child in children:
		var is_valid = true
		for agent in G.player_agents.values():
			var car = get_car_by_agent(agent)
			if car && car.translation.distance_to(child.translation) < min_clearenece_at_spawn:
				is_valid = false
				break
		if is_valid:
			return child
	return null

func get_car_by_agent_id(agent_id: int) -> Car:
	if has_node(str(agent_id)):
		return get_node(str(agent_id)) as Car
	return null

func get_car_by_agent(agent) -> Car:
	return get_car_by_agent_id(agent.id)

func set_car_to_agent(agent, new_car: Car) -> Car:
	var current_car = get_car_by_agent(agent)
	if current_car:
		current_car.queue_free()
	new_car.name = str(agent.id)
	new_car.set_network_master(agent.network_id)
	if agent.agent_type == 'player':
		new_car.set_script(load("res://cars/PlayerCar.gd"))
	else:
		new_car.set_script(load("res://cars/Car.gd"))
	add_child(new_car)
	return new_car

func load_car_for_agent(agent) -> Car:
	return load("res://cars/" + agent.car_name + '.tscn').instance()

remotesync func spawn_car_at_location(agent, location: Vector3, rotation: Vector3):
	print("Spawning ", agent.name, " at location ", location)
	var car = set_car_to_agent(agent, load_car_for_agent(agent))
	car.translation = location
	car.rotation = rotation

func spawn_car(agent):
	var available_spawn_point = get_available_spawn_point()
	if available_spawn_point:
		print("Spawning " + agent.name + " at " + available_spawn_point.name)
		rpc("spawn_car_at_location", agent, available_spawn_point.translation, available_spawn_point.rotation)

func get_car_from_agent(agent) -> Car:
	return get_node(str(agent.id)) as Car
