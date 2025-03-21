extends Control
class_name BaseScene

@export var should_reset: bool

func reset():
	pass

func scene_theme():
	return preload("res://sounds/music/song-Menu.mp3")
