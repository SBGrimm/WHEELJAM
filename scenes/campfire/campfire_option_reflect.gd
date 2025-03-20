extends "res://scenes/campfire/campfire_option.gd"

func _execute():
	EventBus.request_scene_change.emit(SceneManager.Scene.ANTILOOT)
