extends "res://scenes/campfire/campfire_option.gd"

func _execute():
	GlobalGamestate.player_hp = clampf(GlobalGamestate.player_hp + 20, 0, GlobalGamestate.player_max_hp)
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
