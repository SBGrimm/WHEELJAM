extends Control
class_name Slot

@onready var label = $Label
@onready var texture_rect = $TextureRect

func reset():
	for child in texture_rect.get_children():
		if child is OuterPart:
			child.queue_free()

func set_part(part: OuterPart):
	texture_rect.add_child(part)
	part.draggable_component.draggable = true
	label.text = part.get_formatted_text()
