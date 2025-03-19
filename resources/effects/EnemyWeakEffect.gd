extends Effect
class_name EnemyWeakEffect

func apply(battlestate):
	battlestate.player_weak += roundi(amount)
