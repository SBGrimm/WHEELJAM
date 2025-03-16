extends Control

@onready var behaviour = $EnemyBehaviour

func get_turn(gamestate: GameState):
	return behaviour.get_outer_parts()
