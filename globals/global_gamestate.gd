extends Node

var num_level = 0
var player_hp = 100
var player_max_hp = 100
var parts = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_strength_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/damage_weak_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/cripple_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/rage_outer_part.tscn"),
]

var enemies = [
	preload("res://scenes/enemies/enemy1/enemy1.tscn"),
	preload("res://scenes/enemies/enemy2/enemy_2.tscn"),
	preload("res://scenes/enemies/enemy3/enemy_3.tscn"),
]

var amounts: PackedFloat32Array = PackedFloat32Array([3,3,0,0])
var missing_amounts: PackedFloat32Array = PackedFloat32Array([0,0,3,3])
var hand_size = 5
var modifiers = [2, 0.5, 3, 2, 1, 1]
var rng = RandomNumberGenerator.new()

func get_battle_state():
	var battlestate = BattleState.new()
	var enemy = enemies[rng.randi_range(0, 2)].instantiate()
	battlestate.enemy = enemy
	battlestate._enemy_hp = enemy.hp
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

func get_antirewards():
	var rng = RandomNumberGenerator.new()
	var rewards: Array[OuterPart] = []
	for i in range(3):
		rewards.append(parts[rng.rand_weighted(amounts)].instantiate())
	return rewards
