extends Spatial

export var rotation_speed := 2.0

onready var player := get_node("../Player")
onready var speech_bubble_pivot := get_node("SpeechBubblePivot")


func _process(delta):
	var player_position := Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
	var pivot_position := Vector2(speech_bubble_pivot.global_transform.origin.x, speech_bubble_pivot.global_transform.origin.z)
	
	var target_rotation := -(pivot_position - player_position).angle()
	var rotation_difference = target_rotation - speech_bubble_pivot.global_transform.basis.get_euler().y
	
	speech_bubble_pivot.rotate(Vector3.UP, rotation_difference)
