extends Effect
class_name DamageEffect

func apply(battlestate: BattleState):
	print("applying damage effect, amount: ", amount)
	battlestate.damage_enemy(roundi(amount))
