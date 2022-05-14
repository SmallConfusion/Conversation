extends Node

var default_number_of_rooms := 8
var number_of_rooms := default_number_of_rooms
var level := 1

func _input(event):
	if event.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func reset_level():
	level = 1
	number_of_rooms = default_number_of_rooms

