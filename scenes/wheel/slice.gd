extends Control
class_name Slice


@export var _mod: float

var mod:
	set(value):
		_mod = value
		set_texture()
		set_overlay()
	get:
		return _mod
		

@onready var art = %art
@onready var overlay = $overlay

const regions = [
	Rect2(0, 0, 313, 284),
	Rect2(410, 0, 313, 284),
	Rect2(731, 0, 313, 284),
	Rect2(1036, 0, 313, 284),
	Rect2(1304, 0, 313, 284),
	Rect2(1536, 0, 313, 284)
]

func set_texture():
	if _mod <= 0.5:
		art.texture.region = regions[5]
	if _mod == 1:
		art.texture.region = regions[4]
	if _mod == 2:
		art.texture.region = regions[2]
	if _mod >= 3:
		art.texture.region = regions[0]

func set_overlay():
	overlay.visible = (_mod >=4) or (_mod <= 0.25)
	
