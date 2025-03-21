extends Node

signal started_drag(area: TextureRect)
signal ended_drag(area: TextureRect)

signal wheel_place_entered(id: int)
signal wheel_place_exited(id: int)

signal update_battle_preview()

signal request_scene_change(scene_name: SceneManager.Scene)

signal encounter_selected(encounter: Node)
