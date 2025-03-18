extends "res://scenes/map/encounters/encounter.gd"

@onready var base_sprite_scale = %BattleSprite.scale

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)
	%BattleSprite.scale = hover_sprite_scale * base_sprite_scale

func encounter():
	EventBus.request_scene_change.emit(SceneManager.Scene.BATTLE)
