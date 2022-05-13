extends Button

export (NodePath) var settings_popup

func _pressed():
	get_node(settings_popup).popup()
