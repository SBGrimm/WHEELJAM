extends BaseScene

func scene_theme(): 
	return preload("res://sounds/music/song-intro.mp3")

func _on_start_over_button_pressed():
	EventBus.request_restart.emit(SceneManager.Scene.MAP)
	$ClickSFX.play()
	
func _on_back_to_menu_button_pressed():
	$ClickSFX.play()
	EventBus.request_restart.emit(SceneManager.Scene.MAIN_MENU)

func _on_back_to_menu_button_mouse_entered() -> void:
	$HoverSFX.play()

func _on_start_over_button_mouse_entered() -> void:
	$HoverSFX.play()

func _on_start_over_button_mouse_exited() -> void:
	$HoverSFX.play()

func _on_back_to_menu_button_mouse_exited() -> void:
	$HoverSFX.play()
