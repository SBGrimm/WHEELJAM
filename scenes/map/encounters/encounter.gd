extends Node2D

@export var selection_enabled = false
@export var available_next_encounters: Array[Node] = []
var is_mouse_hovering = false
var hover_sprite_scale = 1.0
@onready var click_sfx = $ClickSFX
@onready var hover_on_sfx = $HoverOnSFX
@onready var hover_off_sfx = $HoverOffSFX

func _on_mouse_entered() -> void:
	is_mouse_hovering = true
	if selection_enabled:
		hover_on_sfx.play()

func _on_mouse_exited() -> void:
	is_mouse_hovering = false
	if selection_enabled:
		hover_off_sfx.play()

func update_sprite_hover_scale(delta: float) -> void:
	var animation_time = .4
	var dest = 1.0
	if is_mouse_hovering and selection_enabled:
		dest = 1.3
	hover_sprite_scale = lerp(dest, hover_sprite_scale, exp(-delta/animation_time))
	scale = hover_sprite_scale * Vector2(1, 1)

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)

func _on_mouse_hover_detection_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int) -> void:
	if event is InputEventMouseButton and selection_enabled and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		encounter_clicked()

func mark_visited():
	var visited_encounter_marker = preload("res://scenes/map/encounters/visited_location_mark.tscn").instantiate()
	visited_encounter_marker.global_position = global_position
	get_parent().add_child(visited_encounter_marker)

func encounter_clicked():
	click_sfx.play()
	mark_visited()
	EventBus.selectable_encounters_changed.emit(available_next_encounters)
	encounter()

func encounter():
	# This one is where screen redirection should happen
	print("Placeholder")
