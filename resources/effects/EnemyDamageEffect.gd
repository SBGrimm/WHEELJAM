extends Effect
class_name EnemyDamageEffect

func apply(gamestate):
	print("applying enemy damage effect, amount: ", amount)
	gamestate.player_hp -= roundi(amount)
