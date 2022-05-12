extends Area

var people := []

var talker := 0

var position := 0
var conversation := 0

var interrupted := false

func _ready():
	randomize()
# warning-ignore:narrowing_conversion
	conversation = floor(rand_range(0, len(Conversations.conversations)))

func start_conversation():
	for potential_person in get_children():
		if potential_person.is_in_group("Person"):
			people.append(potential_person)
	
	converse()


func converse():
	while not interrupted:
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
			yield(get_tree().create_timer(5), "timeout")


func interrupt():
	for person in people:
		person.interrupt()
	
	interrupted = true


func is_interrupted():
	return interrupted
