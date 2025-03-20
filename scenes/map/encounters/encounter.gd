extends Node2D

@export var selection_enabled = false
@export var available_next_encounters: Array[Node] = []
var is_mouse_hovering = false
var hover_sprite_scale = 1.0
@onready var click_sfx = $ClickSFX
@onready var hover_on_sfx = $HoverOnSFX
@onready var hover_off_sfx = $HoverOffSFX
@onready var animated_sprite = $AnimatedSprite
@onready var mark_selected = $MarkSelected
@onready var mark_visited = $MarkVisited

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
	if not selection_enabled:
		hover_sprite_scale = 1.
	scale = hover_sprite_scale * Vector2(1, 1)

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)

func _on_mouse_hover_detection_input_event(
	viewport: Node,
	event: InputEvent,
	shape_idx: int) -> void:
	if event is InputEventMouseButton and selection_enabled and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		encounter_clicked()

func encounter_clicked():
	click_sfx.play()
	start_selection_animation()
	EventBus.encounter_selected.emit(self)


func encounter():
	# This one is where screen redirection should happen
	print("Placeholder")

func _ready() -> void:
	stop_animation()

func stop_animation() -> void:
	animated_sprite.stop()
	animated_sprite.frame = 0

func start_animation() -> void:
	animated_sprite.play()

func set_animation(should_start: bool) -> void:
	if should_start:
		start_animation()
	else:
		stop_animation()

func start_selection_animation() -> void:
	mark_selected.visible = true
	mark_selected.frame = 0
	mark_selected.play()

func hide_selection_animation() -> void:
	mark_selected.visible = false
	
func start_visited_animation() -> void:
	mark_visited.visible = true
	mark_visited.frame = 0
	mark_visited.play()
