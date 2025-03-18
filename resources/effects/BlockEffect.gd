extends Effect
class_name BlockEffect

func apply(battlestate):
	print("applying block effect, amount: ", amount)
	battlestate.player_block += roundi(amount)
