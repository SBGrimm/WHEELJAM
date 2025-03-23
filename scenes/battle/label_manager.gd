extends Node

@onready var enemy_display = %EnemyDisplay
@onready var player_display = %PlayerDisplay
#@onready var preview = %Preview
@onready var preview_label = %PreviewLabel

@onready var gamestate_display_dict = {
	"player_hp": player_display.hp,
	"player_block": player_display.block,
	"enemy_hp": enemy_display.hp,
	"enemy_block": enemy_display.block,
	"player_status": player_display.status,
	"enemy_status": enemy_display.status,
}

var symbols = {
	"hp": "[img={40}x{40}]res://assets/icons/hearts.png[/img]", 
	"block": "[img={40}x{40}]res://assets/icons/shields.png[/img]", 
	"strength": "[img={40}x{40}]res://assets/icons/strength.png[/img]",
	"weak": " [img={40}x{40}]res://assets/icons/weakness.png[/img]",
}

func update_preview(selection: WheelSelection, battlestate: BattleState):
	preview_label.text = selection.part.get_formatted_text(selection.mod, battlestate.player_status, battlestate.enemy_status)

func get_symbol(amount: int, property: String):
	if property.split("_")[1] == "status":
			if amount>=0:
				return symbols["strength"]
			else:
				return symbols["weak"]
	else :
		return symbols[property.split("_")[1]]
		

func update_gamestate_display(battlestate, property):
	if property == "all":
		for subproperty in gamestate_display_dict.keys():
			update_gamestate_display(battlestate, subproperty)
	else:
		var amount = battlestate.get(property)
		gamestate_display_dict[property].text = "[center]" + str(amount) + get_symbol(amount, property) + "[/center]"
