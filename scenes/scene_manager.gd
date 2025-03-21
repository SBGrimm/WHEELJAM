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
	SHRINE,
	VICTORY
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
	Scene.SHRINE: preload("res://scenes/shrine/shrine.tscn").instantiate(),
	Scene.VICTORY: preload("res://scenes/menus/WictoryScreen.tscn").instantiate(),
}

func start_track(theme):
	if %ThemePlayer.stream != theme:
		%ThemePlayer.stream = theme
		%ThemePlayer.play()
		print("New track")

func go_to_scene(scene_name: Scene):
	if scene_name == Scene.MAP:
		if GlobalGamestate.is_on_boss:
			go_to_scene(Scene.VICTORY)
			return
	scene_host.add_child(scenes[scene_name])
	scenes[scene_name].hide()
	if scenes[scene_name].should_reset:
		scenes[scene_name].reset()
	var callback = func():
		scenes[scene_name].show()
		current_scene = scene_name
		start_track(scenes[scene_name].scene_theme())
		if scene_name == Scene.MAP:
			scenes[scene_name].start_animation()
	get_tree().create_timer(0.1).timeout.connect(callback)
	

func remove_scene(scene_name: Scene):
	scene_host.remove_child(scenes[scene_name])

var switching = false

func restart(to: Scene):
	switch_scene(to)
	GlobalGamestate.hard_reset()

func switch_scene(to: Scene):
	const scene_switching_pause = .8
	whispers.pick_random().play()
	scene_fadeout.visible = true
	scene_fadeout.color[3] = 0
	switching = true
	await get_tree().create_timer(scene_switching_pause).timeout
	remove_scene(current_scene)
	go_to_scene(to)
	scene_fadeout.visible = false
	switching = false

func _ready():
	EventBus.request_scene_change.connect(switch_scene)
	EventBus.request_restart.connect(restart)
	go_to_scene(Scene.MAIN_MENU)

func _physics_process(delta: float) -> void:
	const fadeout_time = .15 # characteristic time, not animation length
	scene_fadeout.color[3] = clamp(
		lerpf(scene_fadeout.color[3], 1, 1 - exp(-delta / fadeout_time)),
		0,
		1,
	)
	%ThemePlayer.volume_db -= delta * 15 * (1 if switching else -1)
	%ThemePlayer.volume_db = clampf(%ThemePlayer.volume_db, -30, 0)
	 
