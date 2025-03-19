extends Effect
class_name BlockEffect

func apply(battlestate):
	battlestate.player_block += roundi(amount)
