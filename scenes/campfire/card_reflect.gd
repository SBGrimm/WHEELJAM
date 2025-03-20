extends ColorRect

signal option_clicked
@onready var click_sfx = %ClickSFX

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton  and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		click_sfx.play()
		print(1)
		option_clicked.emit()

func _on_mouse_entered() -> void:
	grab_focus()
	color = Color8(25, 25, 25, 255)


func _on_mouse_exited() -> void:
	color = Color8(0, 0, 0, 255)
