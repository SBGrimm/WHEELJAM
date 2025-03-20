extends Label

@onready var click_sfx = %ClickSFX

func _on_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int) -> void:
	if event is InputEventMouseButton  and event.is_pressed() and event.button_index == 1:
		encounter_clicked()


func encounter_clicked():
	click_sfx.play()
	GlobalGamestate.player_hp = clamp(GlobalGamestate.player_hp + 20, 0, GlobalGamestate.player_max_hp)
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
