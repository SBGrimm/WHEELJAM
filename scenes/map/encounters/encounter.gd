extends Node2D

@export var selection_enabled = false
@export var available_next_encounters : Array[Node] = []
var is_mouse_hovering = false
var hover_sprite_scale = 1.0

func enable_selection() -> void:
	selection_enabled = true

func disable_seelction() -> void:
	selection_enabled = false
	
func _on_mouse_entered() -> void:
	is_mouse_hovering = true

func _on_mouse_exited() -> void:
	is_mouse_hovering = false

func update_sprite_hover_scale(delta: float) -> void:
	var animation_time = .6
	var dest = 1.0
	if is_mouse_hovering and selection_enabled:
		dest = 1.3
	hover_sprite_scale = lerp(dest, hover_sprite_scale, exp(-delta/animation_time))

func _on_mouse_hover_detection_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int) -> void:
	if event is InputEventMouseButton and selection_enabled and event.is_pressed():
		encounter_clicked()

func encounter_clicked():
	var visited_encounter_marker = preload("res://scenes/map/encounters/visited_location_mark.tscn").instantiate()
	visited_encounter_marker.global_position = global_position
	get_parent().add_child(visited_encounter_marker)
	selection_enabled = false
	for next_encounter in available_next_encounters:
		next_encounter.selection_enabled = true
	encounter()

func encounter():
	# This one is where screen redirection should happen
	print("Placeholder")
