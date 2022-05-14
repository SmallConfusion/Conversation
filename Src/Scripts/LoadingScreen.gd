extends Control


func _ready():
	$Label.text = "Loading...\nLevel " + str(Global.level)
