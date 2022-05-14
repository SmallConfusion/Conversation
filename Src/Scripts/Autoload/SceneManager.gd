extends CanvasLayer

signal fade_finished

onready var animation_player := get_node("AnimationPlayer")
onready var fade_rect := get_node("TextureRect")

func fade_to(scene):
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	var screenshot = ImageTexture.new()
	screenshot.create_from_image(img)
	fade_rect.texture = screenshot
	get_tree().change_scene(scene)
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	emit_signal("fade_finished")

func fade():
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	var screenshot = ImageTexture.new()
	screenshot.create_from_image(img)
	fade_rect.texture = screenshot
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	emit_signal("fade_finished")
