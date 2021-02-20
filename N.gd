extends Node

var _my_last_sender_id: int
func get_last_sender_id() -> int:
	if _my_last_sender_id == -1:
		return get_tree().get_rpc_sender_id()
	else:
		return _my_last_sender_id

func my_rpc_id_0(node: Node, id: int, function_name: String):
	if id == node.get_tree().get_network_unique_id():
		_my_last_sender_id = id
		node.call(function_name)
		_my_last_sender_id = -1
	else:
		node.rpc_id(id, function_name)

func my_rpc_id_1(node: Node, id: int, function_name: String, param1):
	if id == node.get_tree().get_network_unique_id():
		_my_last_sender_id = id
		node.call(function_name, param1)
		_my_last_sender_id = -1
	else:
		node.rpc_id(id, function_name, param1)

func my_rpc_id_2(node: Node, id: int, function_name: String, param1, param2):
	if id == node.get_tree().get_network_unique_id():
		_my_last_sender_id = id
		node.call(function_name, param1, param2)
		_my_last_sender_id = -1
	else:
		node.rpc_id(id, function_name, param1, param2)
