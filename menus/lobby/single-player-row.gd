extends HBoxContainer

var player_id = -1

func _ready():
	G.connect("player_left", self, "on_player_left")
	if player_id == G.my_id():
		$PlayerName.add_color_override("font_color", Color.greenyellow)

func on_player_left(id: int):
	if id == player_id:
		queue_free()

func _process(delta):
	if player_id != -1:
		if G.player_agents.has(player_id):
			$PlayerName.text = G.player_agents[player_id].name
			$CarName.text = G.player_agents[player_id].car_name
