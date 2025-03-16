extends Effect
class_name DamageEffect

func apply(gamestate):
	print("applying damage effect, amount: ", amount)
	gamestate.damage_enemy(roundi(amount))
