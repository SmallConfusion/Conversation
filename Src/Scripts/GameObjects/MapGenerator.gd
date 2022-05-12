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


export (PackedScene) var wall_scene
export (PackedScene) var doorframe_scene
export (PackedScene) var floor_ceiling_scene


func _ready():
	generate_map()


func generate_map():
	var map = generate_map_array()
	print_map(map)
	place_map(map)


func generate_map_array():
	randomize()
	
	# Generates empty map
	var size = 8
	
	var map = []
	
	for i in size:
		var row = []
		for j in size:
			row.append(1)
		map.append(row)
	
	# Generate map
	var steps := 10
	var xpos := floor(size/2)
	var ypos := xpos
	
	# 0: up, 1: right, 2: down, 3: left
	var direction := 0
	
	
	for i in steps:
		direction = floor(rand_range(0, 4))
		
		# Give my position an exit in the direction I'm facing
		var facing_mulitplier := 1
		
		match direction:
			0:
				facing_mulitplier = 2
			1:
				facing_mulitplier = 3
			2:
				facing_mulitplier = 5
			3:
				facing_mulitplier = 7
		
		map[ypos][xpos] *= facing_mulitplier
		
		match direction:
			0:
				if ypos > 0:
					ypos -= 1
			1:
				if xpos < size-1:
					xpos += 1
			2:
				if ypos < size-1:
					ypos += 1
			3:
				if xpos > 0:
					xpos -= 1
		
		
		# Puts matching exit in room I'm currently in
		facing_mulitplier = 1
		
		match direction:
			2:
				facing_mulitplier = 2
			3:
				facing_mulitplier = 3
			0:
				facing_mulitplier = 5
			1:
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
	var room_size = 3
	var wall_width = 2
	
	var base_x = x * room_size * wall_width
	var base_y = y * room_size * wall_width
	
	# generate floors and ceilings
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

func place(to_place, x, y, r = 0):
	var place = to_place.instance()
	place.translation = Vector3(x, 0, y)
	place.rotation_degrees.y = r
	add_child(place)
	

func print_map(map):
	for row in map:
		var line = ""
		
		for cell in row:
			line += str(cell) + " "
		
		print(line)
