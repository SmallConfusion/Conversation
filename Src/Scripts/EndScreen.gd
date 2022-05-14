extends Control


func win():
	visible = true
	$Panel/Label.text = "You win!"


func lose():
	visible = true
	$Panel/Label.text = "You lose!"
