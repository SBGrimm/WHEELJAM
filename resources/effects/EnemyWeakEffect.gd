extends Effect
class_name EnemyWeakEffect

func apply(battlestate):
	print("applying enemy weak effect, amount: ", amount)
	battlestate.player_weak += roundi(amount)
