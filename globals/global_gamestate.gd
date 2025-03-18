extends Node

var num_level = 0
var player_hp = 100
var deck = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_outer_part.tscn"),
]
var amounts: PackedFloat32Array = PackedFloat32Array([3,3])
var hand_size = 5

func get_battle_state():
	var battlestate = BattleState.new()
	battlestate._player_hp = player_hp
	battlestate._player_block = 0
	battlestate.hand_size = hand_size
	battlestate.amounts = amounts
	return battlestate
