extends Control
class_name DropZone2

@onready var selection_sfx = $SelectionSFX
@onready var pit_art = $PitArt
@onready var hover_detector = $HoverDetector

const textures = {
	"open": preload("res://assets/pit/pit0001.png"),
	"closed": preload("res://assets/pit/pit0000.png") 
}

signal part_chosen(part: OuterPart)

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
	pit_art.texture = textures["open"]

func _on_hover_detector_mouse_exited():
	pit_art.texture = textures["closed"]
