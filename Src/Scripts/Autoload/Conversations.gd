extends Node

var conversations = [
	[
		"Did you know that McDonald's is unhealthy?",
		"No, why didn't you tell me earlier?",
		"I've been eating it for every meal since I was a kid.",
		"Well, not anymore!",
		"No. I care about my health.",
		"I don't want to die young, so I'm quitting right now... Well, maybe tomorrow, you know?",
		"Oh yeah. You can't just quit cold turkey. That's more dangerous than continuing to eat McDonald's for the rest of your life!",
		"Oh! Well, in that case, I don't think it's a good idea to quit at all.",
		"You're right. I'm going to continue eating for the rest of my life. It is delicous after all.",
		"Nothing is more delicous than McDonald's."
	],
	[
		"I go to the gym every day. I work out for five hours every day.",
		"That's really impressive! How do make time for that?",
		"It's simple. You've just got to get on that sigma grind, you know.",
		"That makes sense. How does one get on the grind, man?",
		"It's easy. You work out, quit drugs, and, the most important step, receive a one million dollar loan from your dad.",
		"Oh! That sounds easy. I'm going to start tomorrow!"
	],
	[
		"Have you heard of the hit game, \"Among Us\"?",
		"Yes! I play Among Us all the time.",
		"When I play Among Us, I like to play as the impostor.",
		"That's pretty sus...",
		"Are you the impostor? You're acting very sus.",
		"I'm not the impostor. I scanned in med bay.",
		"I saw you vent though.",
		"I'm voting red. They're very sus.",
		"No it's white for sure. They vented."
	],
	[
		"Dude, NFTs are the next big thing. Do you see these people buying pictures for millions of dollars?",
		"It's insane. They have got to be massively overvalued, though, right?",
		"No, these jpegs are worth the millions of dollars people are paying. Plus, they're an investment!",
		"Is it a good investment though?",
		"Yes! There is nothing smarter to invest your money in right now.",
		"Wow! How much money have you made on them?",
		"Uhhh... Well... I haven't made any money yet, but that's only because I've invested in a lot of the smaller NFTs. If I would have bought the big ones, I would have made so much money.",
		"Sure you would have."
	],
	[
		"Fly me to the moon, and let me play Among Us"
	],
	[
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"...",
		"Well, this is awkward.",
		"...",
		"...",
		"...",
		"...",
	],
	[
		"We're no strangers to love",
		"You know the rules and so do I",
		"A full commitment's what I'm thinking of",
		"You wouldn't get this from any other guy",
		"I just wanna tell you how I'm feeling",
		"Gotta make you understand",
		"Never gonna give you up",
		"Never gonna let you down",
		"Never gonna run around and desert you",
		"Never gonna make you cry",
		"Never gonna say goodbye",
		"Never gonna tell a lie and hurt you",
		"We've known each other for so long",
		"Your heart's been aching, but you're too shy to say it",
		"Inside, we both know what's been going on",
		"We know the game, and we're gonna play it",
		"And if you ask me how I'm feeling",
		"Don't tell me you're too blind to see",
		"Never gonna give you up",
		"Never gonna let you down",
		"Never gonna run around and desert you",
		"Never gonna make you cry",
		"Never gonna say goodbye",
		"Never gonna tell a lie and hurt you",
		"Never gonna give you up",
		"Never gonna let you down",
		"Never gonna run around and desert you",
		"Never gonna make you cry",
		"Never gonna say goodbye",
		"Never gonna tell a lie and hurt you"
	],
	[
		"Fried chicken is my favorite food. I ate so much, now I feel sick.",
		"Try eating some edible chalk. It helps with your stomach. Here, have some!",
		"BLEEAAAAAAHHH, that's horrible! I feel even worse now.",
		"Here have some magic healing crystals.",
		"No.",
		"Yes, have some!",
		"Ok I'll try some."
	],
	[
		"Here, have a cheese stick. It's reall good.",
		"Wow, thanks! I love cheese sticks.",
		"I know, right! They're so fun to string.",
		"I perfer to bite them instead of string them.",
		"Sorry, but you're wrong.",
		"No, you're wrong. Stringing is way better.",
		"Yeah, no cheese sticks were meant to be bitten. That's why they're called \"STICKS\""
	],
	[
		"Water is my favorite drink. I drink like three gallons a day!",
		"Those are rookie numbers. I drink nine gallons a day.",
		"No, you can't drink that much, it's not healthy!",
		"NO, yOU cAn't drInk thAt mUch, It's nOt hEALthy! Go drink a coke.",
	],
	[
		"Are you up for bowling tonight?",
		"They're not open tonight.",
		"Oh! I didn't know that.",
		"They're open on weekends only.",
		"Okay. How about Friday night?",
		"What time?",
		"7-7:30?",
		"Sorry. I already have plans with Jen and Alex for supper.",
		"Well, I want to go bowling!",
		"So do I!",
		"Would any of you mind if Jen and Alex joined us? Then, I could come.",
		"I wouldn't mind. Do any of you mind?",
		"I don't!",
		"Me either!",
		"Do any of you want to meet Jen, Alex, and me for supper at 5. Then, we go bowing after? Could that work?",
		"I think that's a great idea! Who's up for supper and bowling? ",
		"I am!",
		"I am too!",
		"Okay! Friday night it is! Supper and bowling!",
		"Okay! Righty-ho! For sure! This is going to be so much fun!",
	],
	[
		"Im so MAD!!! I got a speeding ticket today!! I didn't deserve it!",
		"Where at?!",
		"Just a block west of the highschool!",
		"Oh yeah! They like to sit there and catch speeders!",
		"How fast were you going?!",
		"85 is all!",
		"YIKES! WHAT WERE YOU THINKING?!! HOW MUCH IS THAT GOING TO COST?",
		"$500!!!",
		"Well, that's a bummer! There goes your summer vacation!",
		"Yeah!!! That's what makes me so mad!!! I'm going home! I can't afford to go anywhere else!",
		"You certainly can't! Bye!",
	]
]


func _ready():
	# Add wednesday easter egg
	var day_of_week = OS.get_datetime()["weekday"]
	
	match day_of_week:
		0:
			day_of_week = "Sunday"
		1:
			day_of_week = "Monday"
		2:
			day_of_week = "Tuesday"
		3:
			day_of_week = "Wednesday"
		4:
			day_of_week = "Thursday"
		5:
			day_of_week = "Friday"
		6:
			day_of_week = "Saturday"
	
	if day_of_week == "Wednesday":
		conversations.append([
			"Hey, what day is it?",
			"It is Wednesday my dudes.",
			"It is Wednesday my dudes.",
			"It is Wednesday my dudes.",
			"It is Wednesday my dudes.",
			"It is Wednesday my dudes.",
			"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
		])
	else:
		conversations.append([
			"Hey, what day is it?",
			"It's " + day_of_week,
			"Oh, thanks!",
			"No problem, bro."
		])
