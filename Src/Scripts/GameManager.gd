extends Spatial

var conversation_managers := []

var started := false
var already_won := false

onready var player := get_node("Player")
onready var map_generator := get_node("MapGenerator")
onready var loading_screen := get_node("CanvasLayer2/LoadingScreen")
onready var end_screen := get_node("EndScreen/Control")
onready var remaining_info := get_node("Info/Control/Label")


func _ready():
	player.connect("die", self, "lose")
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
		var remaining := 0
		
		for manager in conversation_managers:
			if not manager.is_interrupted():
				remaining += 1
		
		remaining_info.text = "Remaining conversations: " + str(remaining)
		
		if remaining <= 0 and not already_won:
			yield(get_tree(), "idle_frame")
			win()


func set_player(pos, rot):
	player.translation = pos
	player.rotation_degrees.y = rot


func win():
	already_won = true
	Global.number_of_rooms = floor((Global.number_of_rooms + 1) * 1.15)
	Global.level += 1
	end_screen.win()
	player.lock()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func lose():
	Global.reset_level()
	end_screen.lose()
	player.lock()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
