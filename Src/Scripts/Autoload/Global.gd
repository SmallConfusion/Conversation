extends Node


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
