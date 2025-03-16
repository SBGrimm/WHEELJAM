extends Effect
class_name EnemyDamageEffect

func apply(gamestate):
	print("applying enemy damage effect, amount: ", amount)
	gamestate.damage_player(roundi(amount))
