extends "res://scenes/campfire/campfire_option.gd"

func _execute():
	GlobalGamestate.player_max_hp += 40
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
