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

var amounts: PackedFloat32Array = PackedFloat32Array([3,3,0,0,0,0])
var missing_amounts: PackedFloat32Array = PackedFloat32Array([0,0,2,2,2,2])
var hand_size = 5
var modifiers = [2, 0.5, 3, 2, 1, 1]
var rng = RandomNumberGenerator.new()

var boss = preload("res://scenes/enemies/boss/boss.tscn")
var is_on_boss = false

func hard_reset():
	num_level = 0
	player_hp = 100
	player_max_hp = 100
	amounts = PackedFloat32Array([3,3,0,0,0,0])
	missing_amounts = PackedFloat32Array([0,0,2,2,2,2])
	hand_size = 5
	modifiers = [2, 0.5, 3, 2, 1, 1]
	is_on_boss = false


func get_battle_state():
	var battlestate = BattleState.new()
	var enemy: Enemy
	if not is_on_boss:
		enemy = enemies[rng.randi_range(0, 2)].instantiate()
	else:
		enemy = boss.instantiate()
	battlestate.enemy = enemy
	battlestate._enemy_hp = enemy.hp
	battlestate._player_hp = player_hp
	battlestate._player_block = 0
	battlestate.parts = parts
	battlestate.hand_size = hand_size
	battlestate.amounts = amounts
	return battlestate

func get_rewards() -> Array[OuterPart]:
	var rng = RandomNumberGenerator.new()
	var rewards: Array[OuterPart] = []
	var tmp_missing_amounts = missing_amounts.duplicate()
	for i in range(3):
		var choice = rng.rand_weighted(tmp_missing_amounts)
		rewards.append(parts[choice].instantiate())
		tmp_missing_amounts[choice] -= 1
	return rewards

func get_antirewards() -> Array[OuterPart]:
	var rng = RandomNumberGenerator.new()
	var rewards: Array[OuterPart] = []
	var tmp_amounts = amounts.duplicate()
	for i in range(3):
		var choice = rng.rand_weighted(tmp_amounts)
		rewards.append(parts[choice].instantiate())
		tmp_amounts[choice]
	return rewards

func get_deck() -> Array[OuterPart]:
	var deck: Array[OuterPart] = []
	for i in range(len(amounts)):
		for j in range(amounts[i]):
			deck.append(parts[i].instantiate())
	return deck
	
