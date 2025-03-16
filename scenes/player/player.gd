extends Control

func draw_cards(gamestate: GameState) -> Array[OuterPart]:
	var rng = RandomNumberGenerator.new()
	var counts = gamestate.amounts.duplicate()
	var drawn: Array[OuterPart] = []
	for i in range(gamestate.hand_size):
		var choice = rng.rand_weighted(counts)
		var part = gamestate.deck[choice]
		drawn.append(part.instantiate())
		counts[choice] -=1
	return drawn
