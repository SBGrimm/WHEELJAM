extends BaseScene

var battlestate: BattleState

@onready var wheel = %Wheel
@onready var fadeout = $FadeOut
@onready var mouse_stopper = $MouseStopper
@onready var enemy = $Enemy
@onready var player = $Player

@onready var enemy_hp_label = $Labels/EnemyHPLabel
@onready var enemy_block_label = $Labels/EnemyBlockLabel
@onready var player_hp_label = $Labels/PlayerHPLabel
@onready var player_block_label = $Labels/PlayerBlockLabel


func _ready():
	wheel.new_dir_chosen.connect(_activate_selection)
	wheel.puzzle_finished.connect(_process_end_turn)
	fadeout.parts_chosen.connect(_on_parts_chosen)

func reset():
	battlestate = GlobalGamestate.get_battle_state()
	battlestate.gamestate_changed.connect(_on_gamestate_changed)
	battlestate.enemy_hp = 40
	update_gamestate_display()
	fadeout.visible = true
	wheel.deactivate()
	fadeout.activate()
	var enemy_parts = enemy.get_turn(battlestate)
	var player_parts = player.draw_cards(battlestate)
	fadeout.reset(player_parts, enemy_parts)
	EventBus.reset_finished.emit()
	

func _activate_selection(selection: WheelSelection):
	for effect: Effect in selection.effects:
		print("activating with amount, mod: ", effect.amount, ", ", selection.mod)
		effect.amount *= selection.mod
		effect.apply(battlestate)

func _on_gamestate_changed():
	GlobalGamestate.player_hp = battlestate.player_hp
	if battlestate.enemy_hp == 0:
		EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
	elif battlestate.player_hp == 0:
		EventBus.request_scene_change.emit(SceneManager.Scene.LOSS_SCREEN)
	else:
		update_gamestate_display()

func update_gamestate_display():
	player_hp_label.text = str(battlestate.player_hp) + "🧡"
	player_block_label.text = str(battlestate.player_block) + "🛡️"
	enemy_hp_label.text = str(battlestate.enemy_hp) + "🧡"
	enemy_block_label.text = str(battlestate.enemy_block) + "🛡️"

func _process_end_turn():
	fadeout.visible = true
	var enemy_parts = enemy.get_turn(battlestate)
	var player_parts = player.draw_cards(battlestate)
	fadeout.reset(player_parts, enemy_parts)
	wheel.deactivate()
	fadeout.activate()
	mouse_stopper.mouse_filter = MOUSE_FILTER_STOP

func _on_parts_chosen(parts: Array[OuterPart]):
	wheel.set_outer_parts(parts)
	wheel.reset()
	wheel.spin()
	wheel.activate()
	mouse_stopper.mouse_filter = MOUSE_FILTER_IGNORE
