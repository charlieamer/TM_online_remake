extends Node

var current_level: Level
func open_level(level_name: String, my_car_name: String, ai_car_names: Array):
	if current_level:
		current_level.queue_free()
	var level_to_load: Level = load("res://levels/" + level_name + ".tscn").instance()
	level_to_load.my_car_name = my_car_name
	level_to_load.ai_car_names = ai_car_names
	add_child(level_to_load)
