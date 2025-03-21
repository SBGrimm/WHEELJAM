extends Control
class_name Enemy

@onready var behaviour = $EnemyBehaviour
@export var hp: int

func get_turn(battlestate: BattleState):
	return behaviour.get_outer_parts()
