extends Spatial

var conversation_managers := []

onready var win_screen := get_node("CanvasLayer/WinScreen")
onready var player := get_node("Player")


func _ready():
	for child in get_children():
		if child.is_in_group("ConversationArea"):
			conversation_managers.append(child)


func _process(delta):
	var are_all_interrupted := true
	
	for manager in conversation_managers:
		if not manager.is_interrupted():
			are_all_interrupted = false
			break
	
	if are_all_interrupted:
		win()


func set_player(pos, rot):
	# Has to use this because onready vars aren't loaded yet
	$Player.translation = pos
	$Player.rotation_degrees.y = rot


func win():
	win_screen.visible = true
