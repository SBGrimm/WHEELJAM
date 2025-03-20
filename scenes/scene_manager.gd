extends Node
class_name SceneManager

@onready var whispers = [
	$WhisperSFX1,
	$WhisperSFX2,
]

@onready var scene_fadeout = %SceneFadeout
@onready var scene_host = %SceneHost # is needed so i can lazily order fadeout


enum Scene {
	MAP,
	BATTLE,
	MAIN_MENU,
	LOSS_SCREEN,
	LOOT,
	CAMPFIRE,
	ANTILOOT,
}

var current_scene: Scene = Scene.MAP
var scenes: Dictionary = {
	Scene.MAP: preload("res://scenes/map/map.tscn").instantiate(),
	Scene.MAIN_MENU: preload("res://scenes/menus/menu.tscn").instantiate(),
	Scene.LOSS_SCREEN: preload("res://scenes/menus/loss_screen.tscn").instantiate(),
	Scene.BATTLE: preload("res://scenes/battle/battle.tscn").instantiate(),
	Scene.LOOT: preload("res://scenes/loot/loot_screen.tscn").instantiate(),
	Scene.CAMPFIRE: preload("res://scenes/campfire/campfire.tscn").instantiate(),
	Scene.ANTILOOT: preload("res://scenes/antiloot/antiloot_screen.tscn").instantiate(),
}

func go_to_scene(scene_name: Scene):
	scene_host.add_child(scenes[scene_name])
	scenes[scene_name].hide()
	if scenes[scene_name].should_reset:
		scenes[scene_name].reset()
	var callback = func():
		scenes[scene_name].show()
		current_scene = scene_name
	get_tree().create_timer(0.1).timeout.connect(callback)

func remove_scene(scene_name: Scene):
	scene_host.remove_child(scenes[scene_name])

func switch_scene(to: Scene):
	const scene_switching_pause = .5
	whispers.pick_random().play()
	scene_fadeout.visible = true
	scene_fadeout.color[3] = 0
	await get_tree().create_timer(scene_switching_pause).timeout
	remove_scene(current_scene)
	go_to_scene(to)
	scene_fadeout.visible = false

func _ready():
	EventBus.request_scene_change.connect(switch_scene)
	go_to_scene(Scene.MAIN_MENU)

func _physics_process(delta: float) -> void:
	const fadeout_time = .15 # characteristic time, not animation length
	scene_fadeout.color[3] = clamp(
		lerpf(scene_fadeout.color[3], 1, 1 - exp(-delta / fadeout_time)),
		0,
		1,
	)
