extends Node

@onready var enemy_display = $EnemyDisplay
@onready var player_display = $PlayerDisplay
@onready var preview = $Preview

@onready var gamestate_display_dict = {
	"player_hp": player_display.hp,
	"player_block": player_display.block,
	"enemy_hp": enemy_display.hp,
	"enemy_block": enemy_display.block
}

var symbols = {
	"player_hp": "🧡", 
	"player_block": "🛡️", 
	"enemy_hp": "🧡", 
	"enemy_block": "🛡️"
}

func update_gamestate_display(battlestate, property):
	if property == "all":
		for subproperty in gamestate_display_dict.keys():
			update_gamestate_display(battlestate, subproperty)
	else:
		gamestate_display_dict[property].text = str(battlestate.get(property)) + symbols[property]
	
func update_preview(battlestate: BattleState, preview_battlestate: BattleState):
	for property in ["player_hp", "player_block", "enemy_hp", "enemy_block"]:
		if battlestate.get(property) != preview_battlestate.get(property):
			preview.preview_dict[property].show()
			preview.preview_dict[property].text = str(preview_battlestate.get(property) - battlestate.get(property)) + symbols[property]
		else:
			preview.preview_dict[property].hide()
			preview.preview_dict[property].text = ""
