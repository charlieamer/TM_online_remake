extends Node

func files_in_folder(path) -> Array:
	var dir = Directory.new()
	var ret = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				ret.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return ret

func all_scenes(path: String) -> Array:
	var ret = []
	var t = ""
	for file in files_in_folder(path):
		if file.ends_with('.tscn'):
			ret.append(file.get_basename())
	return ret

func all_cars():
	return all_scenes('res://cars')

func all_levels():
	return all_scenes('res://levels')
