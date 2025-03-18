extends Resource
class_name BattleState

@export var _player_hp = 0
@export var _enemy_hp = 0
@export var _player_block = 0
@export var _enemy_block = 0
@export var hand_size = 5
@export var deck = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_outer_part.tscn"),
]
@export var amounts: PackedFloat32Array = PackedFloat32Array([3,3])

signal gamestate_changed

var player_hp:
	get:
		return _player_hp
	set(value):
		var changed = (clampi(value, 0, 999) != _player_hp)
		_player_hp = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
			print("change")
var enemy_hp:
	get:
		return _enemy_hp
	set(value):
		var changed = (clampi(value, 0, 999) != _enemy_hp)
		_enemy_hp = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
			print("change")
var player_block:
	get:
		return _player_block
	set(value):
		var changed = (clampi(value, 0, 999) != _player_block)
		_player_block = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
			print("change")
var enemy_block:
	get:
		return _enemy_block
	set(value):
		var changed = (clampi(value, 0, 999) != _enemy_block)
		_enemy_block = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
			print("change")

func damage_player(damage):
	if player_block > 0:
		if damage > player_block:
			player_block = 0
			player_hp -= (damage - player_block)
		else:
			player_block -= damage
	else:
		player_hp -= damage

func damage_enemy(damage):
	if enemy_block > 0:
		if damage > enemy_block:
			enemy_block = 0
			enemy_hp -= (damage - enemy_block)
		else:
			enemy_block -= damage
	else:
		enemy_hp -= damage
