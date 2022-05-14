extends CanvasLayer

signal pause
signal resume

var can_pause = true

onready var pause_menu := get_node("PauseMenu")

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		if pause_menu.visible:
			pause_menu.visible = false
			emit_signal("resume")
		else:
			if can_pause:
				pause_menu.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				emit_signal("pause")
