extends Spatial

# Alright so here we go.
# 2 = up
# 3 = right
# 5 = down
# 7 = left
# 
# Each cell on the map is a number divisible by any number of these numbers.
# If the cell is divisible by a number, then it has an exit on that side.
# 1 is empty.

# Let's see if I can pull this off.
# Update it's working so far

signal map_generated

export var map_size := 16
export var map_generation_steps := 20

export var room_group_ratio := 0.4
export var room_size := 5

export (PackedScene) var wall_scene
export (PackedScene) var doorframe_scene
export (PackedScene) var floor_ceiling_scene
export (PackedScene) var ceiling_light_scene

export (PackedScene) var conversation_manager_scene
export (PackedScene) var person_scene

var player_spawn_position = null
var player_spawn_rotation = null

var wall_width := 2.0


onready var game_manager := get_node("../")


func _ready():
	generate_map()
	game_manager.set_player(player_spawn_position, player_spawn_rotation)
	emit_signal("map_generated")


func generate_map():
	var map = generate_map_array()
	print_map(map)
	place_map(map)
	print("Placed map")
	place_people(map)
	print("Placed people")

func generate_map_array():
	randomize()
	
	# Generates empty map
	var map = []
	
	for i in map_size:
		var row = []
		for j in map_size:
			row.append(1)
		map.append(row)
	
	# Generate map
	var xpos := floor(map_size/2)
	var ypos := xpos
	
	# 0: up, 1: right, 2: down, 3: left
	var direction := 0
	
	
	for i in map_generation_steps:
# warning-ignore:narrowing_conversion
		direction = floor(rand_range(0, 4))
		
		var can_move_in_direction = (direction == 0 and ypos > 0) or \
									(direction == 2 and ypos < map_size - 1) or \
									(direction == 3 and xpos > 0) or \
									(direction == 1 and xpos < map_size - 1)
		
		if can_move_in_direction:
			# Give my position an exit in the direction I'm facing
			var facing_mulitplier := 1
			
			if direction == 0:
				facing_mulitplier = 2
			elif direction == 1:
				facing_mulitplier = 3
			elif direction == 2:
				facing_mulitplier = 5
			elif direction == 3:
				facing_mulitplier = 7
			
			map[ypos][xpos] *= facing_mulitplier
			
			if direction == 0:
				if ypos > 0:
					ypos -= 1
			elif direction == 1:
				if xpos < map_size-1:
					xpos += 1
			elif direction == 2:
				if ypos < map_size-1:
					ypos += 1
			elif direction == 3:
				if xpos > 0:
					xpos -= 1
			
			
			# Puts matching exit in room I'm currently in
			facing_mulitplier = 1
			
			if direction == 2:
				facing_mulitplier = 2
			elif direction == 3:
				facing_mulitplier = 3
			elif direction == 0:
				facing_mulitplier = 5
			elif direction == 1:
				facing_mulitplier = 7
			
			map[ypos][xpos] *= facing_mulitplier
		
	return map


func place_map(map):
	for i in len(map):
		var row = map[i]
		
		for j in len(row):
			var cell = row[j]
			
			if cell > 1:
				generate_room(cell, i, j)


func generate_room(exits, x, y):
	var base_x = x * room_size * wall_width
	var base_y = y * room_size * wall_width
	
	var center_of_room = get_room_center(x, y)
	
	place(ceiling_light_scene, center_of_room[0], center_of_room[1])
	
	# Set spawn position if needed
	if not player_spawn_position:
		player_spawn_position = Vector3(center_of_room[0], 0, center_of_room[1])
		
		if exits % 2 == 0:
			player_spawn_rotation = 90
		elif exits % 3 == 0:
			player_spawn_rotation = 180
		elif exits % 5 == 0:
			player_spawn_rotation = 270
		elif exits % 7 == 0:
			player_spawn_rotation = 0
	
	# Place floors
	for i in room_size:
		for j in room_size:
			var xpos = wall_width * i + base_x
			var ypos = wall_width * j + base_y
			
			place(floor_ceiling_scene, xpos, ypos)
	
	
	# Generate walls and doorframes around the perimeter
	# I'm almost 100% sure that the orientations of these walls are messed up in some way
	
	# Front, right, back, left
	var door_sides = [exits % 2 == 0,
					exits % 3 == 0, 
					exits % 5 == 0, 
					exits % 7 == 0]
	
	
	for i in room_size:
		var to_place = wall_scene
		
		# Back wall
		# These statements check if the side needs a door, and if it does, then it randomly places
		# A doorframe at that position
		if door_sides[2] and i == floor((room_size-1)/2):
			to_place = doorframe_scene
			
		else:
			to_place = wall_scene 
		
		place(to_place, base_x + (room_size-1) * wall_width, base_y + i * wall_width)
		
		# Left wall
		if door_sides[3] and i == floor((room_size-1)/2):
			to_place = doorframe_scene
		else:
			to_place = wall_scene

		place(to_place, base_x + i * wall_width, base_y, 90)

		# Front wall
		if door_sides[0] and i == ceil((room_size-1)/2):
			to_place = doorframe_scene
		else:
			to_place = wall_scene
		
		place(to_place, base_x, base_y + i * wall_width, 180)

		# Right wall
		if door_sides[1] and i == ceil((room_size-1)/2):
			to_place = doorframe_scene
		else:
			to_place = wall_scene

		place(to_place, base_x + i * wall_width, base_y + (room_size-1) * wall_width, 270)


func place_people(map):
	var rooms := []
	var is_first = true
	
	for i in len(map):
		var row = map[i]
		
		for j in len(row):
			var cell = row[j]
			
			if cell > 1:
				# Player is placed in the first room
				if is_first:
					is_first = false
				else:
					rooms.append([i, j])
	
	var num_groups := len(rooms) * room_group_ratio
	
	rooms.shuffle()
	
	for i in num_groups:
		var room = rooms[i]
		var center = get_room_center(room[0], room[1])
		
		var conversation_manager = conversation_manager_scene.instance()
		
		conversation_manager.translation = Vector3(center[0], 0, center[1])
		conversation_manager.rotation.y = randf() * PI * 2
		
		connect("map_generated", conversation_manager, "start_conversation")
		
		var min_place_radius = 1.5
		var max_place_radius = 2.5
		
		var other_rotation_variance = 0.1
		var local_rotation_variance = 0.1
		
		var people_to_generate = floor(rand_range(2, 6))
		
		for j in people_to_generate:
			var person = person_scene.instance()
			
			var person_position = Vector2.UP * rand_range(min_place_radius, max_place_radius)
			person_position = person_position.rotated(j * (PI*2/people_to_generate) + rand_range(-other_rotation_variance, other_rotation_variance))
			
			person.translation = Vector3(person_position.x, 0, person_position.y)
			
			# I have no idea why this works
			person.rotation.y = PI - person_position.angle() + rand_range(-local_rotation_variance, local_rotation_variance)
			
			conversation_manager.add_child(person)
		
		add_child(conversation_manager)

func get_room_center(x, y):
	return [x * room_size * wall_width + room_size / 2 * wall_width,
			y * room_size * wall_width + room_size / 2 * wall_width]


func place(to_place, x, y, r = 0):
	var place = to_place.instance()
	place.translation = Vector3(x, 0, y)
	place.rotation_degrees.y = r
	add_child(place)
	return place


func print_map(map):
	for row in map:
		var line = ""
		
		for cell in row:
			line += str(cell) + " "
		
		print(line)
