extends TextureRect
class_name DraggableComponent

@export var draggable = false
var lifted = false
var lift_timeout = false
@onready var root = $".."
var drag_timer: Timer
@onready var sfx = $LiftedPartSFX

func _ready():
	drag_timer = Timer.new()
	drag_timer.one_shot = true
	drag_timer.wait_time = 0.1
	self.add_child(drag_timer)
	drag_timer.timeout.connect(_timeout)

func _timeout():
	lift_timeout = false

func _unhandled_input(event):
	if !draggable:
		return
	if event is InputEventMouseButton and event.is_released():
		if not lift_timeout:
			lifted = false
			EventBus.ended_drag.emit(self)
	if lifted and event is InputEventMouseMotion:
		root.global_position += event.relative

func _gui_input(event):
	if !draggable:
		return
	if event is InputEventMouseButton and event.pressed:
		if not lifted:
			sfx.play()
			EventBus.started_drag.emit(self)
			lifted = true
			lift_timeout = true
			drag_timer.start()
