extends Effect
class_name BlockEffect

func apply(gamestate):
	print("applying block effect, amount: ", amount)
	gamestate.player_block += roundi(amount)
