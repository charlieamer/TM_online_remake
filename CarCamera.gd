extends Spatial

var initial_local_translation: Vector3
var initial_local_rotation: Vector3

func _ready():
	initial_local_translation = translation
	initial_local_rotation = rotation
	set_as_toplevel(true)

func _process(delta):
	translation = get_parent_spatial().translation + initial_local_translation
	rotation = Vector3(0, get_parent_spatial().rotation.y, 0) + initial_local_rotation
