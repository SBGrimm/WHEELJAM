extends Effect
class_name DamageEffect

func apply(gamestate):
	print("applying damage effect, amount: ", amount)
	gamestate.enemy_hp -= roundi(amount)
