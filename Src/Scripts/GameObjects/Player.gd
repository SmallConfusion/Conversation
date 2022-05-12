extends KinematicBody

var gravity := -30.0
var friction := 0.9
var speed := 5.0
var mouse_sensitivity := 0.002

var velocity = Vector3()

onready var camera_pivot := get_node("Pivot")
onready var conversation_area := get_node("ConversationArea")
onready var interrupt_hint := get_node("CanvasLayer/Control/InterruptHint")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	# Get interruptable conversations
	var interruptable_conversations := []
	
	for potential_conversation in conversation_area.get_overlapping_areas():
		if potential_conversation.is_in_group("ConversationArea") and not potential_conversation.is_interrupted():
			interruptable_conversations.append(potential_conversation)
	
	interrupt_hint.visible = len(interruptable_conversations) > 0
	
	if Input.is_action_just_pressed("Interrupt"):
		if len(interruptable_conversations) > 0:
			var min_length = INF
			var min_length_conversation
			
			for conversation in interruptable_conversations:
				var distance = global_transform.origin.distance_squared_to(conversation.global_transform.origin)
				
				if distance < min_length:
					min_length = distance
					min_length_conversation = conversation
			
			min_length_conversation.interrupt()


func _physics_process(delta):
	# Move
	velocity.x *= friction
	velocity.z *= friction
	velocity.y += gravity * delta
	
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -1.2, 1.2)
	elif event is InputEventMouseButton and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("Forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("Back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("Left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("Right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

