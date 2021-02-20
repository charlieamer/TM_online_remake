extends Node

func _ready():
	get_tree().connect("network_peer_connected", self, "on_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "on_player_disconnected")
	# get_tree().connect("connected_to_server", self, "_connected_ok")
	# get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")

############################################
### CONNECTION
############################################
var current_scene: String
remotesync var room_owner: int
var is_initial_data_loaded = false

signal initial_data_received
signal player_joined(id)
signal player_left(id)

func init_match_data():
	player_agents = {}
	level_name = "test"
	is_initial_data_loaded = false

remotesync func change_scene(new_scene: String):
	print("Changing scene to: ", new_scene)
	get_tree().change_scene("res://" + new_scene + ".tscn")
	current_scene = new_scene
	if get_tree().is_network_server():
		for id in player_agents:
			player_agents[id].ready = false
		rset("player_agents", player_agents)

func host_locally(port: int, max_players: int):
	init_match_data()
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, max_players)
	get_tree().network_peer = peer
	current_scene = "menus/lobby/lobby"
	var id = get_tree().get_network_unique_id()
	room_owner = id
	on_peer_connected(id)

func join(ip: String, port: int):
	init_match_data()
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer

func on_peer_connected(id: int):
	print("Connected: ", id)
	if get_tree().is_network_server():
		register_agent("Player " + str(player_agents.size() + 1), 'player', 'test', id)
		N.my_rpc_id_1(self, id, "change_scene", current_scene)

func on_player_disconnected(id: int):
	print("Disconnected: ", id)
	player_agents.erase(id)
	if get_tree().is_network_server():
		rset("player_agents", player_agents)
	emit_signal("player_left", id)

remote func on_player_joined(id: int):
	emit_signal("player_joined", id)

slave func on_initial_data_received():
	print("Initial data received: ", player_agents)
	emit_signal("initial_data_received")
	for id in player_agents.keys():
		on_player_joined(id)

master func send_initial_data():
	var id = N.get_last_sender_id()
	print("Send initial data to: ", id)
	rset_id(id, "room_owner", room_owner)
	rset_id(id, "player_agents", player_agents)
	rset_id(id, "level_name", level_name)
	print("Initial data for ", id, ": ", player_agents)
	N.my_rpc_id_0(self, id, "on_initial_data_received")
	for other_id in player_agents.keys():
		if other_id != id:
			N.my_rpc_id_1(self, other_id, "on_player_joined", id)

func try_request_initial_data():
	if !is_initial_data_loaded:
		is_initial_data_loaded = true
		N.my_rpc_id_0(self, 1, "send_initial_data")

master func level_ready():
	player_agents[N.get_last_sender_id()].ready = true
	rset("player_agents", player_agents)

func level_locally_ready():
	print("Level locally ready")
	try_request_initial_data()
	N.my_rpc_id_0(self, 1, "level_ready")

func lobby_locally_ready():
	print("Lobby locally ready")
	try_request_initial_data()

func disconnect_from_game():
	get_tree().network_peer.close_connection()
	on_server_disconnected()

func on_server_disconnected():
	change_scene("menus/test-level-opener")

func get_non_ready_players():
	var ret = []
	for id in player_agents:
		if !player_agents[id].ready:
			ret.append(id)
	return ret

func is_everyone_ready():
	return get_non_ready_players().size() == 0

############################################
### AGENTS
############################################
puppetsync var player_agents: Dictionary
puppetsync var level_name: String

func my_id() -> int:
	return get_tree().get_network_unique_id()

func my_agent():
	return player_agents[my_id()]

# agent_type can be: 'ai', 'player'
func register_agent(agent_name: String, agent_type: String, car_name: String, id: int):
	print("Register agent ", id)
	var new_agent = {}
	new_agent.agent_type = agent_type
	new_agent.car_name = car_name
	new_agent.name = agent_name
	new_agent.id = id
	new_agent.network_id = 1 if id < 0 else id
	new_agent.ready = false
	player_agents[id] = new_agent
	rset("player_agents", player_agents)
	return new_agent

master func set_agent_property(property_name: String, property_value):
	var id = N.get_last_sender_id()
	player_agents[id][property_name] = property_value
	rset("player_agents", player_agents)

func set_my_name(new_name: String):
	N.my_rpc_id_2(self, 1, "set_agent_property", "name", new_name)

func set_my_car(new_car: String):
	N.my_rpc_id_2(self, 1, "set_agent_property", "car_name", new_car)

master func _set_level(new_level: String):
	if N.get_last_sender_id() == room_owner:
		rset("level_name", new_level)

func set_level(new_level: String):
	N.my_rpc_id_1(self, 1, "_set_level", new_level)

master func _open_selected_level():
	if N.get_last_sender_id() == room_owner:
		rpc("change_scene", "levels/" + level_name)

func open_selected_level():
	N.my_rpc_id_0(self, 1, "_open_selected_level")
