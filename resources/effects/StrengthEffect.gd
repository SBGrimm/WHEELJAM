extends Effect
class_name StrengthEffect

func apply(battlestate):
	battlestate.player_status += roundi(amount)
