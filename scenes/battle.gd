extends Control

@onready var wheel = $Wheel
@export var gamestate: GameState
@onready var fadeout = $FadeOut
@onready var label1 = $Label
@onready var label_2 = $Label2

func _ready():
	wheel.new_dir_chosen.connect(_activate_selection)
	wheel.puzzle_finished.connect(_process_end_turn)
	gamestate.gamestate_changed.connect(update_gamestate_display)
	fadeout.visible = false
	update_gamestate_display()
	
func _activate_selection(selection: WheelSelection):
	for effect: Effect in selection.effects:
		print("activating with amount, mod: ", effect.amount, ", ", selection.mod)
		effect.amount *= selection.mod
		effect.apply(gamestate)

func update_gamestate_display():
	label1.text = str(gamestate.player_hp)
	label_2.text = str(gamestate.enemy_hp)

func _process_end_turn():
	#сброситься колесо
	#зум колеса
	#набор колеса
	pass
