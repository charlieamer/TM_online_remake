extends "res://menus/Menu.gd"

func _on_JoinButton_pressed():
	G.join("localhost", 1234)

func _on_HostButton_pressed():
	G.host_locally(1234, 10)
