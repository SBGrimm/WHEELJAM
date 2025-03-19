extends Control
class_name DropZone

signal part_chosen(part: OuterPart)

func _on_dropped(area: TextureRect):
	if not area.is_in_group("droppable"):
		return
	if not area.get_global_rect().intersects(self.get_global_rect(), true):
		return
	area.remove_from_group("droppable")
	area.draggable = false
	part_chosen.emit(area.root)
