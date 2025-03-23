extends Control

@export var id: int
@onready var hover_detector = $HoverDetector

func _ready():
	hover_detector.mouse_entered.connect(_on_hover_detector_mouse_entered)
	hover_detector.mouse_exited.connect(_on_hover_detector_mouse_exited)

func activate():
	hover_detector.monitoring = true
	hover_detector.input_pickable = true

func deactivate():
	hover_detector.monitoring = false
	hover_detector.input_pickable = false
	
func _on_hover_detector_mouse_entered():
	EventBus.wheel_place_entered.emit(self.id)

func _on_hover_detector_mouse_exited():
	EventBus.wheel_place_exited.emit(self.id)
