extends Control

@export var number_sections = 3
var selectable_encounters: Array[Node]

enum Encounter {
	Battle,
	DarkShrine,
	Campfire,
}

const encounters = {
	Encounter.Battle: preload("res://scenes/map/encounters/battle.tscn"),
	Encounter.DarkShrine: preload("res://scenes/map/encounters/dark_shrine.tscn"),
	Encounter.Campfire: preload("res://scenes/map/encounters/campfire.tscn"),
}

const peacefull_encounters = [
	Encounter.DarkShrine,
	Encounter.Campfire,
]

const passage = preload("res://scenes/map/encounters/passage.tscn")

func place_encounter_at_passage(encounter_type: Encounter, passage: Node) -> Node:
	var encounter = encounters[encounter_type].instantiate()
	encounter.global_position = passage.get_encounter_position()
	add_child(encounter)
	return encounter

func place_passage_at(encounter: Node) -> Node:
	var _passage = passage.instantiate()
	_passage.global_position = encounter.global_position
	add_child(_passage)
	return _passage

func generate_bifurcation(
	starting_encounter: Node,
	passage_length: float = 1,
	angle: float = PI / 5) -> Node:
	var bifurcation_encounter_types = [
		peacefull_encounters.pick_random(),
		Encounter.values().pick_random(),
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
		Encounter.values().pick_random(),
		passage_down,
	)
	starting_encounter.available_next_encounters.append(bottom_encounter_1)
	var passage_horizontal = place_passage_at(bottom_encounter_1)
	var bottom_encounter_2 = place_encounter_at_passage(
		Encounter.values().pick_random(),
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
	var first_encounter = encounters[Encounter.Battle].instantiate()
	selectable_encounters.append(first_encounter)
	first_encounter.selection_enabled = true
	first_encounter.global_position = %MapEntrance.global_position
	add_child(first_encounter)
	var last_encounter = first_encounter
	for section in range(number_sections):
		last_encounter = generators.pick_random().call(last_encounter)

func set_selection(encounters: Array[Node], selection_enabled: bool):
	for encounter in encounters:
		encounter.selection_enabled = selection_enabled

func update_selectable_encounters(new_selectable_encounters: Array[Node]) -> void:
	set_selection(selectable_encounters, false)
	set_selection(new_selectable_encounters, true)
	selectable_encounters = new_selectable_encounters

func _ready() -> void:
	generate_map()
	set_selection(selectable_encounters, true)
	EventBus.selectable_encounters_changed.connect(update_selectable_encounters)
