extends Spatial

# Something is throwing an error here, something about the viewport texture I
# think. I hope it wont break things.

signal finished_talking

export var rotation_speed := 2.0
export var talk_speed := 0.05

var talk_string := ""
var talk_position := 0.0
var still_talking := false
var interrupted := false

onready var player := get_node("../../Player")
onready var speech_bubble_pivot := get_node("SpeechBubblePivot")
onready var speech_bubble := get_node("Viewport/SpeechBubble")
onready var animation_player := get_node("AnimationPlayer")
onready var tween := get_node("Tween")


func _process(delta):
	if not interrupted:
		rotate_bubble()
		update_talk(delta)
	else:
		$"SpeechBubblePivot/SpeechBubble".visible = false

func talk(text):
	talk_string = text
	talk_position = 0
	speech_bubble.set_text("")
	animation_player.play("FadeInBubble")


func update_talk(delta):
	if still_talking:
		talk_position += delta
		var character_number = floor(talk_position / talk_speed)
		speech_bubble.set_text(talk_string.substr(0, character_number))
		
		if character_number >= talk_string.length():
			still_talking = false
			emit_signal("finished_talking")
			animation_player.play("FadeOutBubble")


func rotate_bubble():
	var player_position := Vector2(player.global_transform.origin.x, player.global_transform.origin.z)
	var pivot_position := Vector2(speech_bubble_pivot.global_transform.origin.x, speech_bubble_pivot.global_transform.origin.z)
	
	var target_rotation := -(pivot_position - player_position).angle()
	var rotation_difference = target_rotation - speech_bubble_pivot.global_transform.basis.get_euler().y
	
	speech_bubble_pivot.rotate(Vector3.UP, rotation_difference)


func start_talking():
	still_talking = true


func interrupt():
	interrupted = true
	still_talking = false
	$"SpeechBubblePivot/SpeechBubble".visible = false
