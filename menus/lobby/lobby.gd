extends Control

onready var StartButton: Button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer3/StartButton
onready var RoomName: Label = $CenterContainer/PanelContainer/VBoxContainer/RoomName
onready var Name: LineEdit = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/Name
onready var CarDropdown: OptionButton = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/CarDropdown
onready var LevelDropdown: OptionButton = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer4/LevelDropdown
onready var PlayerRows: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer/PanelContainer/PlayerRows

func _data_ready():
	RoomName.text = "Room name"
	if G.room_owner != G.my_id():
		StartButton.hide()
		for idx in range(LevelDropdown.get_item_count()):
			LevelDropdown.set_item_disabled(idx, true)
	Name.text = G.my_agent().name
	select_car(G.my_agent().car_name)
	select_level(G.level_name)

func _player_joined(id: int):
	var row = preload("res://menus/lobby/single-player-row.tscn").instance()
	row.player_id = id
	PlayerRows.add_child(row)

func select_level(level_name: String):
	for idx in range(LevelDropdown.get_item_count()):
		if LevelDropdown.get_item_text(idx) == level_name:
			LevelDropdown.select(idx)

func select_car(car_name: String):
	for idx in range(CarDropdown.get_item_count()):
		if CarDropdown.get_item_text(idx) == car_name:
			CarDropdown.select(idx)

func _ready():
	G.connect("initial_data_received", self, "_data_ready")
	G.connect("player_joined", self, "_player_joined")
	for car_name in U.all_cars():
		CarDropdown.add_item(car_name)
	for level_name in U.all_levels():
		LevelDropdown.add_item(level_name)
	G.lobby_locally_ready()

func _process(_delta):
	if G.room_owner != G.my_id():
		select_level(G.level_name)

func _on_DisconnectButton_pressed():
	G.disconnect_from_game()

func _on_Name_text_changed(new_text: String):
	G.set_my_name(new_text)

func _on_StartButton_pressed():
	G.open_selected_level()


func _on_CarDropdown_item_selected(index):
	G.set_my_car(CarDropdown.get_item_text(index))

func _on_LevelDropdown_item_selected(index):
	G.set_level(LevelDropdown.get_item_text(index))
