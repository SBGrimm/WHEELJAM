extends BaseScene

@onready var start_button = $StartButton
@onready var exit_button = $ExitButton

func _on_exit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
