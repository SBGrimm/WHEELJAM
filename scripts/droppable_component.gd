extends Area2D

signal part_slotted()
signal part_unslotted()

@export var target_coords: Vector2
@export var target_degrees: int
@export var anim_time = 0.5
@export var id: int

enum STATE {AWAITING_DROP, ANIMATING, OCCUPIED}

var state = STATE.AWAITING_DROP

var possible_drops: Array[Area2D] = []

func _ready():
	EventBus.ended_drag.connect(_on_dropped)

func _on_dropped(area: Area2D):
	if state != STATE.AWAITING_DROP: 
		return
	if not area.is_in_group("droppable"):
		return
	if area not in possible_drops:
		return
	state = STATE.ANIMATING
	area.remove_from_group("droppable")
	area.draggable = false
	var tween:Tween = create_tween()
	tween.set_trans(7)
	tween.set_parallel(true)
	tween.tween_property(area.root, "rotation_degrees", target_degrees,anim_time).from_current()
	tween.tween_property(area.root, "global_position", target_coords, anim_time).from_current()
	tween.finished.connect(_on_slot_animation_ended)
	area.root.reparent(self)
	
func _on_slot_animation_ended():
	state = STATE.OCCUPIED
	part_slotted.emit()

func _on_area_entered(area: Area2D):
	if area.is_in_group("droppable"):
		possible_drops.append(area)

func _on_area_exited(area: Area2D):
	if area.is_in_group("droppable"):
		possible_drops.erase(area)
