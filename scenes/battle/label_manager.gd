extends Node

@onready var enemy_display = $EnemyDisplay
@onready var player_display = $PlayerDisplay
@onready var preview = $Preview

@onready var gamestate_display_dict = {
	"player_hp": player_display.hp,
	"player_block": player_display.block,
	"enemy_hp": enemy_display.hp,
	"enemy_block": enemy_display.block,
	"player_status": player_display.status,
	"enemy_status": enemy_display.status,
}

var symbols = {
	"hp": "🧡", 
	"block": "🛡️", 
	"strength": "💪",
	"weak": "🥀",
}

func get_symbol(amount: int, property: String):
	if property.split("_")[1] == "status":
			if amount>0:
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
		gamestate_display_dict[property].text = str(amount) + get_symbol(amount, property)
	
func update_preview(battlestate: BattleState, preview_battlestate: BattleState):
	for property in ["player_hp", "player_block", "player_status", "enemy_hp", "enemy_block", "enemy_status"]:
		if battlestate.get(property) != preview_battlestate.get(property):
			preview.preview_dict[property].show()
			var amount = preview_battlestate.get(property) - battlestate.get(property)
			preview.preview_dict[property].text = str(amount) + get_symbol(amount, property)
		else:
			preview.preview_dict[property].hide()
			preview.preview_dict[property].text = ""
