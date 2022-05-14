extends Button


func _pressed():
	FadeManager.fade()
	get_tree().reload_current_scene()
