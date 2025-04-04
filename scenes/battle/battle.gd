extends BaseScene

var battlestate: BattleState

@onready var wheel = %Wheel
@onready var fadeout = $FadeOut
@onready var mouse_stopper = $MouseStopper
var enemy: Enemy
@onready var label_manager = $LabelManager

func is_battle_intense():
	if GlobalGamestate.is_on_boss:
		return true
	const intensity_hp_treshold = 0.3
	const intensity_probability = 0.3
	var low_hp = (GlobalGamestate.player_hp <
		GlobalGamestate.player_max_hp * intensity_hp_treshold)
	return low_hp and (randf() < intensity_probability)

func scene_theme():
	if is_battle_intense():
		return preload("res://sounds/music/song-battle-intense.mp3")
	return preload("res://sounds/music/song-battle.mp3")
	
func _ready():
	wheel.new_dir_hovered.connect(_on_wheel_dir_hovered)
	wheel.new_dir_chosen.connect(_activate_selection)
	wheel.puzzle_finished.connect(_process_end_turn)
	fadeout.parts_chosen.connect(_on_parts_chosen)

func reset():
	battlestate = GlobalGamestate.get_battle_state()
	if enemy != null:
		remove_child(enemy)
	add_child(battlestate.enemy)
	enemy = battlestate.enemy
	battlestate.gamestate_changed.connect(_on_gamestate_changed)
	label_manager.update_gamestate_display(battlestate, "all")
	fadeout.visible = true
	wheel.deactivate()
	wheel.reset()
	fadeout.activate()
	var enemy_parts = enemy.get_turn(battlestate)
	var player_parts = battlestate.draw_cards()
	fadeout.reset(player_parts, enemy_parts)
	
func _activate_selection(selection: WheelSelection):
	for effect: Effect in selection.effects:
		var temp_effect = effect.duplicate()
		temp_effect.amount *= selection.mod
		temp_effect.apply(battlestate)

func generate_preview_data(selection: WheelSelection):
	var temp_battlestate = battlestate.duplicate()
	for effect: Effect in selection.effects:
		var temp_effect = effect.duplicate()
		temp_effect.amount *= selection.mod
		temp_effect.apply(temp_battlestate)
	return temp_battlestate

func _on_gamestate_changed(property: String):
	if property == "player_hp":
		GlobalGamestate.player_hp = battlestate.player_hp
		if battlestate.player_hp == 0:
			EventBus.request_scene_change.emit(SceneManager.Scene.LOSS_SCREEN)
	if property == "enemy_hp":
		if battlestate.enemy_hp == 0:
			EventBus.request_scene_change.emit(SceneManager.Scene.LOOT)
	label_manager.update_gamestate_display(battlestate, property)

func _process_end_turn():
	fadeout.visible = true
	var enemy_parts = enemy.get_turn(battlestate)
	var player_parts = battlestate.draw_cards()
	fadeout.reset(player_parts, enemy_parts)
	wheel.deactivate()
	fadeout.activate()
	mouse_stopper.mouse_filter = MOUSE_FILTER_STOP

func _on_parts_chosen(parts: Array[OuterPart]):
	wheel.set_outer_parts(parts)
	wheel.reset()
	wheel.activate()
	wheel.spin()
	mouse_stopper.mouse_filter = MOUSE_FILTER_IGNORE

func _on_wheel_dir_hovered():
	var selection = wheel.get_current_wheel_selection()
	label_manager.update_preview(selection, battlestate)
