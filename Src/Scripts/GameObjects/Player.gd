extends KinematicBody

var gravity := -30.0
var friction := 0.9
var speed := 5.0
var mouse_sensitivity := 0.002

var velocity = Vector3()

var locked = false

onready var camera_pivot := get_node("Pivot")
onready var conversation_area := get_node("ConversationArea")
onready var interrupt_hint := get_node("CanvasLayer/Control/InterruptHint")


func _process(delta):
	Debug.player_position = translation
	
	if not locked:
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
	if not locked:
		# Move
		velocity.x *= friction
		velocity.z *= friction

		if Debug.noclip:
			velocity.y *= friction
		else:
			velocity.y += gravity * delta

		var desired_velocity = get_input() * (Debug.speed if Debug.speed else speed)

		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z

		if Debug.noclip:
			velocity.y = 0
			
			if Input.is_action_pressed("Up"):
				velocity.y += Debug.speed if Debug.speed else speed
			
			if Input.is_action_pressed("Down"):
				velocity.y -= Debug.speed if Debug.speed else speed
			
			translation += velocity * delta
		else:
			velocity = move_and_slide(velocity, Vector3.UP, true)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -1.2, 1.2)
	elif event is InputEventMouseButton and not locked:
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


func lock():
	locked = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func unlock():
	locked = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

