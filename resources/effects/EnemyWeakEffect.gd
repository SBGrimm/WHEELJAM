extends Effect
class_name EnemyWeakEffect

func apply(battlestate):
	battlestate.enemy_status -= roundi(amount)
