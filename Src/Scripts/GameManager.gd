extends Spatial

var conversation_managers := []

var started := false

onready var win_screen := get_node("CanvasLayer/WinScreen")
onready var player := get_node("Player")
onready var map_generator := get_node("MapGenerator")

func _ready():
	map_generator.connect("map_generated", self, "map_generated")

func map_generated():
	for child in map_generator.get_children():
		if child.is_in_group("ConversationArea"):
			conversation_managers.append(child)
	
	started = true

func _process(delta):
	if started:
		var are_all_interrupted := true
		
		for manager in conversation_managers:
			if not manager.is_interrupted():
				are_all_interrupted = false
				break

		if are_all_interrupted:
			win()

func set_player(pos, rot):
	player.translation = pos
	player.rotation_degrees.y = rot


func win():
	win_screen.visible = true
