extends Control

@onready var behaviour = $EnemyBehaviour

func get_turn(battlestate: BattleState):
	return behaviour.get_outer_parts()
