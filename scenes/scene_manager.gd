extends Node
class_name SceneManager

enum Scene {
	MAP,
	BATTLE,
	MAIN_MENU,
	LOSS_SCREEN
}

var current_scene: Scene = Scene.MAP
var scenes: Dictionary = {
	Scene.MAP: preload("res://scenes/map/map.tscn").instantiate(),
	Scene.MAIN_MENU: preload("res://scenes/menus/menu.tscn").instantiate(),
	Scene.LOSS_SCREEN: preload("res://scenes/menus/loss_screen.tscn").instantiate(),
	Scene.BATTLE: preload("res://scenes/battle/battle.tscn").instantiate(),
}

func go_to_scene(scene_name: Scene):
	add_child(scenes[scene_name])
	scenes[scene_name].hide()
	if scenes[scene_name].should_reset:
		scenes[scene_name].reset()
	var callback = func():
		scenes[scene_name].show()
		current_scene = scene_name
	get_tree().create_timer(0.05).timeout.connect(callback)

func remove_scene(scene_name: Scene):
	remove_child(scenes[scene_name])

func switch_scene(to: Scene):
	print(1)
	remove_scene(current_scene)
	go_to_scene(to)

func _ready():
	EventBus.request_scene_change.connect(switch_scene)
	go_to_scene(Scene.MAIN_MENU)
