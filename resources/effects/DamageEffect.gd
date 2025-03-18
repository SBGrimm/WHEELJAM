extends Effect
class_name DamageEffect

func apply(battlestate):
	print("applying damage effect, amount: ", amount)
	battlestate.damage_enemy(roundi(amount))
