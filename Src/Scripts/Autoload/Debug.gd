extends Node

onready var debug_label := get_node("Control/Debug")
onready var debug_menu := get_node("Control/Panel")

var debug_mode := false

var noclip = false
var speed = null
var infinite_battery = false

var player_position = null

var cheat_code = [
	KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A
]

var cheat_code_pos := 0


func _input(e):
	if e is InputEventKey and e.pressed:
		if debug_mode:
			if e.is_action_pressed("DebugKey"):
				debug_menu.visible = not debug_menu.visible
				
				if debug_menu.visible:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			if e.scancode == cheat_code[cheat_code_pos]:
				cheat_code_pos += 1
				if cheat_code_pos == len(cheat_code):
					debug_mode = true
					debug_menu.visible = true
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
			elif e.scancode == cheat_code[0]:
				cheat_code_pos = 1
			else:
				cheat_code_pos = 0


func _process(delta):
	debug_label.text = \
		"FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) + "\n" + \
		"Player position: " + str(player_position)


func _on_DebugInfo_toggled(button_pressed):
	debug_label.visible = button_pressed


func _on_Noclip_toggled(button_pressed):
	noclip = button_pressed


func _on_Speed_text_changed(new_text):
	# Null is a valid value for this
	speed = float(new_text)


func _on_LoseHealth_toggled(button_pressed):
	infinite_battery = button_pressed
