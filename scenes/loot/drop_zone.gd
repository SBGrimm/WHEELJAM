extends Control
class_name DropZone

@onready var selection_sfx = $SelectionSFX
@onready var hover_detector = $HoverDetector
@onready var sack_art = %SackArt

signal part_chosen(part: OuterPart)

const textures = {
	"open": preload("res://assets/sack/sack0001.png"),
	"closed": preload("res://assets/sack/sack0000.png") 
}

func _ready():
	hover_detector.mouse_entered.connect(_on_hover_detector_mouse_entered)
	hover_detector.mouse_exited.connect(_on_hover_detector_mouse_exited)

func _on_dropped(area: TextureRect):
	if not area.is_in_group("droppable"):
		return
	if not area.get_global_rect().intersects(self.get_global_rect(), true):
		return
	selection_sfx.play()
	area.remove_from_group("droppable")
	area.draggable = false
	part_chosen.emit(area.root)

func _on_hover_detector_mouse_entered():
	sack_art.texture = textures["open"]

func _on_hover_detector_mouse_exited():
	sack_art.texture = textures["closed"]
