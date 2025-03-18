extends Control

func draw_cards(battlestate: BattleState) -> Array[OuterPart]:
	var rng = RandomNumberGenerator.new()
	var counts = battlestate.amounts.duplicate()
	var drawn: Array[OuterPart] = []
	for i in range(battlestate.hand_size):
		var choice = rng.rand_weighted(counts)
		var part = battlestate.deck[choice]
		drawn.append(part.instantiate())
		counts[choice] -=1
	return drawn
