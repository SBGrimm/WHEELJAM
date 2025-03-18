extends Effect
class_name EnemyDamageEffect

func apply(battlestate):
	print("applying enemy damage effect, amount: ", amount)
	battlestate.damage_player(roundi(amount))
