extends Spatial

func _ready():
	generate_map()

func generate_map():
	var size = 8
	
	var map = []
	
	for i in size:
		var row = []
		for j in size:
			row.append(false)
		map.append(row)
	
	print_map(map)


func print_map(map):
	for row in map:
		var line = ""
		
		for cell in row:
			line += "X" if cell else "O"
			line += " "
		
		print(line)
