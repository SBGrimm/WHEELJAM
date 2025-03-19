extends Effect
class_name EnemyDamageEffect

func apply(battlestate):
	battlestate.damage_player(roundi(amount))
