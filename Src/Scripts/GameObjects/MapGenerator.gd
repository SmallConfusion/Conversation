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

func _ready():
	generate_map()


func generate_map():
	var map = generate_map_array()
	print_map(map)

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

func print_map(map):
	for row in map:
		var line = ""
		
		for cell in row:
			line += str(cell) + " "
		
		print(line)
