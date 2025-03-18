extends BaseScene

func _on_start_over_button_pressed():
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)

func _on_back_to_menu_button_pressed():
	EventBus.request_scene_change.emit(SceneManager.Scene.MAIN_MENU)
