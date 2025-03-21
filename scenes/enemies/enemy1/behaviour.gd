extends EnemyBehaviour

var deck = [
	preload("res://scenes/Outer Parts/monster/enemy_claw_outer_part.tscn"),
	preload("res://scenes/Outer Parts/monster/enemy_block_outer_part.tscn")
]

var weights = PackedFloat32Array([2, 1])


func get_outer_parts() -> Array[OuterPart]:
	var parts: Array[OuterPart] = []
	var rng = RandomNumberGenerator.new()
	var w_copy = weights.duplicate()
	for i in range(3):
		var choice = rng.rand_weighted(w_copy)
		parts.append(deck[choice].instantiate())
		w_copy[choice]-=1
	return parts
