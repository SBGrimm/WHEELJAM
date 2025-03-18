extends Effect
class_name EnemyStrengthEffect

func apply(battlestate):
	print("applying enemy strength effect, amount: ", amount)
	battlestate.enemy_strength += roundi(amount)
