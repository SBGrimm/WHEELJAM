extends Control

@onready var label = $Label

func reset():
	for child in get_children():
		if child is OuterPart:
			child.queue_free()

func set_part(part: OuterPart):
	add_child(part)
	part.draggable_component.draggable = true
	label.text = part.get_formatted_text()
