extends BaseScene

@onready var start_button = $StartButton
@onready var exit_button = $ExitButton
@onready var sfx_click = $ClickSFX

func _on_exit_button_pressed():
	sfx_click.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()

func _on_start_button_pressed():
	sfx_click.play()
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
