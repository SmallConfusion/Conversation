extends CanvasLayer

signal fade_finished
signal fade_half

onready var animation_player := get_node("AnimationPlayer")

func fade_to(scene):
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	emit_signal("fade_half")
	get_tree().change_scene(scene)
	animation_player.play_backwards("fade")
	emit_signal("fade_finished")

func fade():
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	emit_signal("fade_half")
	animation_player.play_backwards("fade")
	emit_signal("fade_finished")
