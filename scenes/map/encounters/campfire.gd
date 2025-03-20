extends "res://scenes/map/encounters/encounter.gd"

func encounter():
	EventBus.request_scene_change.emit(SceneManager.Scene.CAMPFIRE)
