extends KinematicBody

var gravity := -30.0
var friction := 0.9
var speed := 8.0
var mouse_sensitivity := 0.002

var velocity = Vector3()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	velocity.x *= friction
	velocity.z *= friction
	velocity.y += gravity * delta
	
	var desired_velocity = get_input() * speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
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
