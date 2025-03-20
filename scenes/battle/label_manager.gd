extends Node

@onready var enemy_display = %EnemyDisplay
@onready var player_display = %PlayerDisplay
@onready var preview = %Preview

@onready var gamestate_display_dict = {
	"player_hp": player_display.hp,
	"player_block": player_display.block,
	"enemy_hp": enemy_display.hp,
	"enemy_block": enemy_display.block,
	"player_status": player_display.status,
	"enemy_status": enemy_display.status,
}

var symbols = {
	"hp": "[img={20}x{20}]res://assets/icons/hearts.png[/img]", 
	"block": "[img={20}x{20}]res://assets/icons/shields.png[/img]", 
	"strength": "[img={20}x{20}]res://assets/icons/strength.png[/img]",
	"weak": "[img={20}x{20}]res://assets/icons/weakness.png[/img]",
}

func _ready():
	EventBus.wheel_place_entered.connect(_on_wheel_place_entered)
	EventBus.wheel_place_exited.connect(_on_wheel_place_exited)

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
		gamestate_display_dict[property].text = "[center]" + str(amount) + get_symbol(amount, property) + "[/center]"
	
func update_preview(battlestate: BattleState, preview_battlestate: BattleState):
	for property in ["player_hp", "player_block", "player_status", "enemy_hp", "enemy_block", "enemy_status"]:
		if battlestate.get(property) != preview_battlestate.get(property):
			var label: RichTextLabel = preview.preview_dict[property]
			label.show()
			var amount = preview_battlestate.get(property) - battlestate.get(property)
			label.text = "[center]" + str(amount) + get_symbol(amount, property) + "[/center]"
		else:
			preview.preview_dict[property].hide()
			preview.preview_dict[property].text = ""

func _on_wheel_place_entered(id: int):
	preview.show()
	
func _on_wheel_place_exited(id: int):
	preview.hide()
