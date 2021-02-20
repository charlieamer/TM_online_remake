extends Control

onready var StartButton: Button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer3/StartButton
onready var RoomName: Label = $CenterContainer/PanelContainer/VBoxContainer/RoomName
onready var Name: LineEdit = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/Name
onready var Car: LineEdit = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/Car
onready var Level: LineEdit = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer4/Level
onready var PlayerRows: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/PlayerRows

func _data_ready():
	RoomName.text = "Room name"
	if G.room_owner != G.my_id():
		StartButton.hide()
		Level.editable = false
	Name.text = G.my_agent().name
	Car.text = G.my_agent().car_name
	Level.text = G.level_name

func _player_joined(id: int):
	var row = preload("res://menus/lobby/single-player-row.tscn").instance()
	row.player_id = id
	PlayerRows.add_child(row)

func _ready():
	G.connect("initial_data_received", self, "_data_ready")
	G.connect("player_joined", self, "_player_joined")
	G.lobby_locally_ready()

func _process(_delta):
	if G.room_owner != G.my_id():
		Level.text = G.level_name

func _on_DisconnectButton_pressed():
	G.disconnect_from_game()

func _on_Name_text_changed(new_text: String):
	G.set_my_name(new_text)

func _on_Car_text_changed(new_text: String):
	G.set_my_car(new_text)

func _on_Level_text_changed(new_text: String):
	if G.room_owner == G.my_id():
		G.set_level(new_text)


func _on_StartButton_pressed():
	G.open_selected_level()
