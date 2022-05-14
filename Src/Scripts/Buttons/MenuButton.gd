extends Button


func _pressed():
	FadeManager.fade()
	get_tree().change_scene("res://Scenes/Screens/Menu.tscn")
