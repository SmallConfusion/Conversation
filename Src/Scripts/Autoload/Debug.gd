extends Node

onready var debug_label := get_node("Control/Label")
var noclip = false
var speed = null

func _ready():
	Console.add_command("toggle_debug", self, "toggle_debug") \
		.set_description("Toggles debug screen.") \
		.register()
	
	Console.add_command("toggle_noclip", self, "toggle_noclip") \
		.set_description("Toggles noclip. Use E and Q to change altitude.") \
		.register()
	
	Console.add_command("set_speed", self, "set_speed") \
		.set_description("Sets speed to %speed%.") \
		.add_argument("Speed", TYPE_REAL) \
		.register()
	
	Console.add_command("reset_speed", self, "reset_speed") \
		.set_description("Resets the speed to default") \
		.register()


func _process(delta):
	debug_label.text = \
		"FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) + "\n"


func toggle_debug():
	debug_label.visible = not debug_label.visible
	Console.write_line("Debug screen is now " + "visible" if debug_label.visible else "hidden")


func toggle_noclip():
	noclip = !noclip
	Console.write_line("Noclip is now " + "active" if noclip else "inactive")


func set_speed(new_speed):
	speed = new_speed
	Console.write_line("Speed set to " + str(speed))


func reset_speed():
	speed = null
	Console.write_line("Reset speed")
