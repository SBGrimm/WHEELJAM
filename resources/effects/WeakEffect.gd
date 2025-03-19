extends Effect
class_name WeakEffect

func apply(battlestate):
	battlestate.player_status -= roundi(amount)
