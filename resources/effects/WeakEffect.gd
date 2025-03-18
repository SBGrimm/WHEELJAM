extends Effect
class_name WeakEffect

func apply(battlestate):
	print("applying weak effect, amount: ", amount)
	battlestate.enemy_weak += roundi(amount)
