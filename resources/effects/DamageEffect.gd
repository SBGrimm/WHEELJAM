extends Effect
class_name DamageEffect

func apply(battlestate: BattleState):
	battlestate.damage_enemy(roundi(amount))
