extends BaseScene

@export var number_sections = 3
var selectable_encounters: Array[Node]

@onready var left_border = %MapEntrance.global_position[0] + 55
@onready var right_border = %MapEntrance.global_position[0]

enum Encounter {
	Battle,
	DarkShrine,
	Campfire,
	Boss,
}

const encounters = {
	Encounter.Battle: preload("res://scenes/map/encounters/battle.tscn"),
	Encounter.DarkShrine: preload("res://scenes/map/encounters/dark_shrine.tscn"),
	Encounter.Campfire: preload("res://scenes/map/encounters/campfire.tscn"),
	Encounter.Boss: preload("res://scenes/map/encounters/boss.tscn"),
}

const peacefull_encounters = [
	Encounter.DarkShrine,
	Encounter.Campfire,
]

const common_encounters = [
	Encounter.DarkShrine,
	Encounter.Campfire,
	Encounter.Battle,
]

const passage = preload("res://scenes/map/encounters/passage.tscn")

func place_encounter_at_passage(encounter_type: Encounter, passage: Node) -> Node:
	var encounter = encounters[encounter_type].instantiate()
	encounter.global_position = passage.get_encounter_position()
	right_border = max(right_border, encounter.global_position[0])
	add_child(encounter)
	return encounter

func place_passage_at(node: Node) -> Node:
	var _passage = passage.instantiate()
	_passage.global_position = node.global_position
	add_child(_passage)
	return _passage

func generate_bifurcation(
	starting_encounter: Node,
	passage_length: float = 1,
	angle: float = PI / 5) -> Node:
	var bifurcation_encounter_types = [
		peacefull_encounters.pick_random(),
		common_encounters.pick_random(),
	]
	bifurcation_encounter_types.shuffle()
	var bottom_passage = place_passage_at(starting_encounter)
	var top_passage = place_passage_at(starting_encounter)
	top_passage.rotate(angle)
	bottom_passage.rotate(-angle)
	top_passage.scale *= passage_length
	bottom_passage.scale *= passage_length
	var top_encounter = place_encounter_at_passage(bifurcation_encounter_types[0], top_passage)
	var bottom_encounter = place_encounter_at_passage(bifurcation_encounter_types[1], bottom_passage)
	starting_encounter.available_next_encounters.append_array([
		top_encounter,
		bottom_encounter,
	])
	var top_passage_closing = place_passage_at(top_encounter)
	var bottom_passage_closing = place_passage_at(bottom_encounter)
	top_passage_closing.rotate(-angle)
	bottom_passage_closing.rotate(angle)
	top_passage_closing.scale *= passage_length
	bottom_passage_closing.scale *= passage_length
	var closing_encounter = place_encounter_at_passage(Encounter.Battle, top_passage_closing)
	top_encounter.available_next_encounters.append(closing_encounter)
	bottom_encounter.available_next_encounters.append(closing_encounter)
	return closing_encounter

func generate_large_section(starting_encounter: Node) -> Node:
	#      --- noncombat
	#     /             \ 
	# ---*---- rand ------- combat ---combat--
	#     \                       /
	#      --- rand --- rand ----
	var bifurcation_end = generate_bifurcation(starting_encounter, .9,  PI / 7)
	var bifurcation_tail_passage = place_passage_at(bifurcation_end)
	var bifurcation_tail = place_encounter_at_passage(Encounter.Battle, bifurcation_tail_passage)
	bifurcation_end.available_next_encounters.append(bifurcation_tail)
	var passage_down = place_passage_at(starting_encounter)
	var angle = PI * 0.27
	if randf() > .5:
		angle *= -1
	passage_down.rotate(angle)
	passage_down.scale *= cos(PI / 7) / cos(angle) * 0.9
	var bottom_encounter_1 = place_encounter_at_passage(
		common_encounters.pick_random(),
		passage_down,
	)
	starting_encounter.available_next_encounters.append(bottom_encounter_1)
	var passage_horizontal = place_passage_at(bottom_encounter_1)
	var bottom_encounter_2 = place_encounter_at_passage(
		common_encounters.pick_random(),
		passage_horizontal,
	)
	bottom_encounter_1.available_next_encounters.append(bottom_encounter_2)
	var returning_passage = place_passage_at(bottom_encounter_2)
	returning_passage.rotate(-angle)
	returning_passage.scale *= cos(PI / 7) / cos(angle) * 0.9
	bottom_encounter_2.available_next_encounters.append(bifurcation_tail)
	return bifurcation_tail

var generators = [
	generate_bifurcation,
	generate_large_section,
]

func generate_map() -> void:
	var intro_passage = place_passage_at(%MapEntrance)
	var last_encounter = place_encounter_at_passage(Encounter.Battle, intro_passage)
	selectable_encounters.append(last_encounter)
	last_encounter.selection_enabled = true
	for section in range(number_sections):
		last_encounter = generators.pick_random().call(last_encounter)
	var boss_passage = place_passage_at(last_encounter)
	var boss = place_encounter_at_passage(Encounter.Boss, boss_passage)
	last_encounter.available_next_encounters.append(boss)

func set_selection(encounters: Array[Node], selection_enabled: bool):
	for encounter in encounters:
		encounter.selection_enabled = selection_enabled
		encounter.set_animation(selection_enabled)

var last_encounter = null
var scrolling_to_encounter = false
var scrolling_to_encounter_init_stutter_time = .7
var scrolling_to_encounter_time = .7
var scrolling_to_encounter_speed: float
var scrolling_to_encounter_decel: float

func start_animation():
	if last_encounter == null:
		return
	last_encounter.hide_selection_animation()
	last_encounter.start_visited_animation()
	await get_tree().create_timer(scrolling_to_encounter_init_stutter_time).timeout
	scrolling_to_encounter = true
	scrolling_to_encounter_decel = 2 * abs(%Camera.global_position[0] - target_scroll_point()) / scrolling_to_encounter_time ** 2
	scrolling_to_encounter_speed = scrolling_to_encounter_decel * scrolling_to_encounter_time
	selectable_encounters = last_encounter.available_next_encounters
	set_selection(last_encounter.available_next_encounters, true)
	var stop_scroll = func():
		scrolling_to_encounter = false
	get_tree().create_timer(scrolling_to_encounter_time).timeout.connect(stop_scroll)

func handle_encounter_selected(encounter: Node) -> void:
	set_selection(selectable_encounters, false)
	last_encounter = encounter
	var circle_animation_time = 6. / 24
	await get_tree().create_timer(circle_animation_time).timeout
	encounter.encounter()

func _ready() -> void:
	generate_map()
	set_selection(selectable_encounters, true)
	EventBus.encounter_selected.connect(handle_encounter_selected)

var scroll_speed = Vector2(0., 0)
const scroll_decel_time = .2
const scroll_max_speed = Vector2(500., 0.)
const scroll_min_speed = 1
const scrolling_wheel_factor = 3.5
var is_left_scroll_pressed = false
var is_right_scroll_pressed = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MapScrollRight"):
		scroll_speed = scroll_max_speed
		is_right_scroll_pressed = true
	if event.is_action_pressed("MapScrollLeft"):
		scroll_speed = -scroll_max_speed
		is_left_scroll_pressed = true
	if event.is_action_released("MapScrollRight"):
		is_right_scroll_pressed = false
	if event.is_action_released("MapScrollLeft"):
		is_left_scroll_pressed = false
	if event.is_action("MouseWheelUp"):
		scroll_speed = -scroll_max_speed * scrolling_wheel_factor
	if event.is_action("MouseWheelDown"):
		scroll_speed = scroll_max_speed * scrolling_wheel_factor

func target_scroll_point() -> float:
	return last_encounter.global_position[0] - 100

func _physics_process(delta: float) -> void:
	if scrolling_to_encounter:
		scrolling_to_encounter_speed -= delta * scrolling_to_encounter_decel
		if %Camera.global_position[0] < target_scroll_point():
			%Camera.global_position[0] = clampf(
				%Camera.global_position[0] + scrolling_to_encounter_speed * delta - scrolling_to_encounter_decel * delta * delta / 2,
				left_border,
				target_scroll_point()
			)
		else:
			%Camera.global_position[0] = clampf(
				%Camera.global_position[0] - scrolling_to_encounter_speed * delta - scrolling_to_encounter_decel * delta * delta / 2,
				target_scroll_point(),
				right_border - 950
			)
		%Camera.global_position[0] = clampf(%Camera.global_position[0], left_border, right_border - 950)
		return
	%Camera.global_position += scroll_speed * delta
	%Camera.global_position[0] = clampf(%Camera.global_position[0], left_border, right_border - 950)
	if not is_left_scroll_pressed and not is_right_scroll_pressed:
		scroll_speed = lerp(scroll_speed, Vector2(0., 0.), 1 - exp(-delta / scroll_decel_time))
	if abs(scroll_speed.x) < scroll_min_speed:
		scroll_speed = Vector2(0, 0)
