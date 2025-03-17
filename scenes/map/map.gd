extends Control

@export var number_layers = 3

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

const passage = preload("res://scenes/map/encounters/passage.tscn")
	
func _ready() -> void:
	var first_encounter = encounters[Encounter.Battle].instantiate()
	first_encounter.selection_enabled = true
	first_encounter.global_position = %MapEntrance.global_position
	add_child(first_encounter)
	var first_passage = passage.instantiate()
	first_passage.global_position = first_encounter.global_position
	add_child(first_passage)
	var last_passage = first_passage
	var last_encounter = first_encounter
	for layer in range(number_layers):
		var encounter = encounters[Encounter.values().pick_random()].instantiate()
		encounter.selection_enabled = false
		encounter.global_position = last_passage.get_encounter_position()
		last_encounter.available_next_encounters.append(encounter)
		add_child(encounter)
		last_encounter = encounter
		if layer != number_layers - 1:
			var _passage = passage.instantiate()
			_passage.global_position = encounter.global_position
			add_child(_passage)
			last_passage = _passage
