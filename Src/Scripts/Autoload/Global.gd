extends Node

var number_of_rooms := 8

func _input(event):
	if event.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
