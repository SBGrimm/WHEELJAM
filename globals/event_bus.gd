extends Node

signal started_drag(area: Area2D)
signal ended_drag(area: Area2D)

signal request_scene_change(scene_name: SceneManager.Scene)
signal reset_finished()

signal selectable_encounters_changed(new_encounters: Array[Node])
