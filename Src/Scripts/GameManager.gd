extends Spatial

var conversation_managers := []

var started := false

onready var win_screen := get_node("CanvasLayer/WinScreen")
onready var player := get_node("Player")
onready var map_generator := get_node("MapGenerator")
onready var loading_screen := get_node("CanvasLayer/LoadingScreen")


func _ready():
	loading_screen.visible = true
	player.lock()
	map_generator.connect("map_generated", self, "map_generated")


func map_generated():
	for child in map_generator.get_children():
		if child.is_in_group("ConversationArea"):
			conversation_managers.append(child)
	
	FadeManager.fade()
	loading_screen.visible = false
	
	yield(FadeManager, "fade_finished")
	player.unlock()
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
