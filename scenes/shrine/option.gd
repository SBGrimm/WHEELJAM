extends TextureRect

signal option_chosen

var _pressed = false

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		_pressed = true
	elif event is InputEventMouseButton and event.is_released():
		_pressed = false
		option_chosen.emit()
