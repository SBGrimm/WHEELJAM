extends ColorRect

signal option_clicked
@onready var click_sfx = %ClickSFX

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton  and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		click_sfx.play()
		option_clicked.emit()

func _on_mouse_entered() -> void:
	grab_focus()
	%Outline.visible = true
	color = Color8(10, 10, 10, 255)
	%HoverSFX.play()


func _on_mouse_exited() -> void:
	%Outline.visible = false
	color = Color8(0, 0, 0, 255)
	%HoverSFX.play()
