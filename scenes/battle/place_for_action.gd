extends Control
class_name OuterPartPlace

signal part_slotted()
signal part_unslotted()

@export var anim_time = 0.5
@onready var action_selection_sfx_list = [
	$"../ActionSelectionSFX1",
	$"../ActionSelectionSFX2",
]
enum STATE {AWAITING_DROP, ANIMATING, OCCUPIED}

var _state = STATE.AWAITING_DROP

var state:
	get:
		return _state
	set(value):
		_state = value

func _ready():
	EventBus.ended_drag.connect(_on_dropped)

func reset():
	for child in get_children():
		if child.is_in_group("droppable"):
			remove_child(child)
	state = STATE.AWAITING_DROP

func _on_dropped(area: TextureRect):
	if state != STATE.AWAITING_DROP: 
		return
	if not area.is_in_group("droppable"):
		return
	if not area.get_global_rect().intersects(self.get_global_rect(), true):
		return
	action_selection_sfx_list.pick_random().play()
	state = STATE.ANIMATING
	area.remove_from_group("droppable")
	area.draggable = false
	area.root.reparent(self)
	var tween:Tween = create_tween()
	tween.set_trans(7)
	tween.tween_property(area.root, "position", Vector2(0, 0), anim_time)
	tween.finished.connect(_on_slot_animation_ended)
	
func _on_slot_animation_ended():
	state = STATE.OCCUPIED
	part_slotted.emit()
