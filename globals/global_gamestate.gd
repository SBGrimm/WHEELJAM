extends Node

var num_level = 0
var player_hp = 100
var parts = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_strength_outer_part.tscn"),	
	preload("res://scenes/Outer Parts/player/damage_weak_outer_part.tscn")
]
var amounts: PackedFloat32Array = PackedFloat32Array([3,3,0,0])
var missing_amounts: PackedFloat32Array = PackedFloat32Array([0,0,3,3])
var hand_size = 5
var modifiers = [2, 0.5, 3, 2, 1, 1]

func get_battle_state():
	var battlestate = BattleState.new()
	battlestate._player_hp = player_hp
	battlestate._player_block = 0
	battlestate.parts = parts
	battlestate.hand_size = hand_size
	battlestate.amounts = amounts
	return battlestate

func get_rewards():
	var rng = RandomNumberGenerator.new()
	var rewards: Array[OuterPart] = []
	for i in range(3):
		rewards.append(parts[rng.rand_weighted(missing_amounts)].instantiate())
	return rewards
