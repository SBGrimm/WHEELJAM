extends Control

@onready var wheel = $Wheel
@export var gamestate: GameState
@onready var fadeout = $FadeOut
@onready var mouse_stopper = $MouseStopper

@onready var enemy_hp_label = $Labels/EnemyHPLabel
@onready var enemy_block_label = $Labels/EnemyBlockLabel
@onready var player_hp_label = $Labels/PlayerHPLabel
@onready var player_block_label = $Labels/PlayerBlockLabel

@onready var enemy = $Enemy
@onready var player = $Player

func _ready():
	wheel.new_dir_chosen.connect(_activate_selection)
	wheel.puzzle_finished.connect(_process_end_turn)
	gamestate.gamestate_changed.connect(update_gamestate_display)
	fadeout.parts_chosen.connect(_on_parts_chosen)
	update_gamestate_display()
	fadeout.visible = true
	wheel.deactivate()
	fadeout.activate()
	var enemy_parts = enemy.get_turn(gamestate)
	var player_parts = player.draw_cards(gamestate)
	fadeout.reset(player_parts, enemy_parts)
	
func _activate_selection(selection: WheelSelection):
	for effect: Effect in selection.effects:
		print("activating with amount, mod: ", effect.amount, ", ", selection.mod)
		effect.amount *= selection.mod
		effect.apply(gamestate)

func update_gamestate_display():
	player_hp_label.text = str(gamestate.player_hp) + "🧡"
	player_block_label.text = str(gamestate.player_block) + "🛡️"
	enemy_hp_label.text = str(gamestate.enemy_hp) + "🧡"
	enemy_block_label.text = str(gamestate.enemy_block) + "🛡️"

func _process_end_turn():
	fadeout.visible = true
	var enemy_parts = enemy.get_turn(gamestate)
	var player_parts = player.draw_cards(gamestate)
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
