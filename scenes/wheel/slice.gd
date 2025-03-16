extends Control
class_name Slice

@export var mod: float
@onready var art = %art

const regions = [
	Rect2(0, 0, 313, 284),
	Rect2(410, 0, 313, 284),
	Rect2(731, 0, 313, 284),
	Rect2(1036, 0, 313, 284),
	Rect2(1304, 0, 313, 284),
	Rect2(1536, 0, 313, 284)
]
func _ready():
	if mod == 0.5:
		art.texture.region = regions[5]
	if mod == 1:
		art.texture.region = regions[4]
	if mod == 2:
		art.texture.region = regions[2]
	if mod == 3:
		art.texture.region = regions[0]
	
