extends Control

signal part_slotted()
signal part_unslotted()

@export var target_coords: Vector2
@export var target_degrees: int
@export var anim_time = 0.5
@export var id: int

enum STATE {AWAITING_DROP, ANIMATING, OCCUPIED}

var state = STATE.AWAITING_DROP

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
	if not area.get_global_rect().intersects(self.get_global_rect()):
		return
	state = STATE.ANIMATING
	area.remove_from_group("droppable")
	area.draggable = false
	var tween:Tween = create_tween()
	tween.set_trans(7)
	tween.set_parallel(true)
	if abs(area.root.rotation_degrees - target_degrees) < 180:
		tween.tween_property(area.root, "rotation_degrees", target_degrees, anim_time).from_current()
	elif abs(area.root.rotation_degrees - (target_degrees - 360)) < 180:
		tween.tween_property(area.root, "rotation_degrees", target_degrees-360, anim_time).from_current()
	elif abs(area.root.rotation_degrees - (target_degrees + 360)) < 180:
		tween.tween_property(area.root, "rotation_degrees", target_degrees+360, anim_time).from_current()
	tween.tween_property(area.root, "global_position", target_coords, anim_time).from_current()
	tween.finished.connect(_on_slot_animation_ended)
	area.root.reparent(self)
	print("done")
	
func _on_slot_animation_ended():
	state = STATE.OCCUPIED
	part_slotted.emit()
