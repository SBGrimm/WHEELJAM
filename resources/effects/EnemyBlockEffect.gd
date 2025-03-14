extends Effect
class_name EnemyBlockEffect

func apply(gamestate):
	print("applying enemy block effect, amount: ", amount)
	gamestate.enemy_block += roundi(amount)
