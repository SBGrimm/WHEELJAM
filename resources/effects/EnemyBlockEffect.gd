extends Effect
class_name EnemyBlockEffect

func apply(battlestate):
	battlestate.enemy_block += roundi(amount)
