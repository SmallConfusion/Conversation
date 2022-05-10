extends Node

var people := []

var talker := 0

var position := 0
var conversation := floor(rand_range(0, len(Conversations.conversations)))

func _ready():
	people = get_children()
	converse()


func converse():
	while true:
		# Find talker
		var next_talker = floor(rand_range(0, len(people)-1))
		
		if next_talker == talker:
			next_talker += 1
		
		talker = next_talker
		
		
		# Get conversation
		var line = Conversations.conversations[conversation][position]
		people[talker].talk(line)
		
		yield(people[talker], "finished_talking")
		
		
		# Increase position
		position += 1
		
		if position >= len(Conversations.conversations[conversation]):
			var new_conversation = floor(rand_range(0, len(Conversations.conversations) - 1))
			
			if new_conversation == conversation:
				new_conversation += 1
			
			conversation = new_conversation
			
			position = 0
			
			# Adds two second wait between conversations
			yield(get_tree().create_timer(2), "timeout")
		
		
