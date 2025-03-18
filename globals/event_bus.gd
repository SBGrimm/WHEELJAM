extends Node

signal started_drag(area: TextureRect)
signal ended_drag(area: TextureRect)

signal update_battle_preview()

signal request_scene_change(scene_name: SceneManager.Scene)
signal reset_finished()

signal selectable_encounters_changed(new_encounters: Array[Node])
