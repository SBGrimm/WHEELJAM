extends Effect
class_name EnemyStrengthEffect

func apply(battlestate):
	battlestate.enemy_status += roundi(amount)
