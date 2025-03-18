extends Effect
class_name EnemyBlockEffect

func apply(battlestate):
	print("applying enemy block effect, amount: ", amount)
	battlestate.enemy_block += roundi(amount)
