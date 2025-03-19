extends Effect
class_name EnemyStrengthEffect

func apply(battlestate):
	battlestate.enemy_strength += roundi(amount)
