extends Area2D

@export var draggable = false
var lifted = false
var lift_timeout = false
@onready var root = $".."
var drag_timer: Timer

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
	if event is InputEventMouseButton and not event.pressed:
		if not lift_timeout:
			lifted = false
	if lifted and event is InputEventMouseMotion:
		root.global_position += event.relative

func _input_event(viewport, event, shape_idx):
	if !draggable:
		return
	if event is InputEventMouseButton and event.pressed:
		if not lifted:
			lifted = true
			lift_timeout = true
			drag_timer.start()
