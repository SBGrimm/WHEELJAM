extends "res://scenes/map/encounters/encounter.gd"

func encounter():
	EventBus.request_scene_change.emit(SceneManager.Scene.BATTLE)

func _ready() -> void:
	stop_animation()
	$AnimatedSpriteMapLongDistance.play()

func start_animation() -> void:
	$AnimatedSpriteMapLongDistance.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play()
