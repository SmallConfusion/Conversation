extends Node

var people := []

var talker := 0


func _ready():
	people = get_children()
	converse()


func converse():
	while true:
		var next_talker = floor(rand_range(0, len(people)-1))
		
		if next_talker == talker:
			next_talker += 1
		
		talker = next_talker
		
		people[talker].talk("Placeholder text, placeholder text, placeholder text, placeholder text, placeholder text, placeholder text, placeholder text, placeholder text, placeholder text")
		
		yield(people[talker], "finished_talking")
