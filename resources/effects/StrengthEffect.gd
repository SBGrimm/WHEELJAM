extends Effect
class_name StrengthEffect

func apply(battlestate):
	print("applying strength effect, amount: ", amount)
	battlestate.player_status += roundi(amount)
