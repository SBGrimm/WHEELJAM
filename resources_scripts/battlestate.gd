extends Resource
class_name BattleState

@export var _player_hp = 0
@export var _enemy_hp = 0
@export var _player_block = 0
@export var _enemy_block = 0
@export var _enemy_str = 0
@export var _enemy_weak = 0
@export var _player_str = 0
@export var _player_weak = 0

@export var hand_size = 5
@export var deck = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn"),
	preload("res://scenes/Outer Parts/player/block_outer_part.tscn"),
]
@export var amounts: PackedFloat32Array = PackedFloat32Array([3,3])

signal gamestate_changed(property: String)

var enemy_str:
	get:
		return _enemy_str
	set(value):
		var is_changed = (clampi(value, 0, 999) != _enemy_str)
		_enemy_str = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("enemy_str")

var enemy_weak:
	get:
		return _enemy_weak
	set(value):
		var is_changed = (clampi(value, 0, 999) != _enemy_weak)
		_enemy_weak = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("enemy_weak")

var player_str:
	get:
		return _player_str
	set(value):
		var is_changed = (clampi(value, 0, 999) != _player_str)
		_player_str = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("player_str")

var player_weak:
	get:
		return _player_weak
	set(value):
		var is_changed = (clampi(value, 0, 999) != _player_weak)
		_player_weak = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("player_weak")

var player_hp:
	get:
		return _player_hp
	set(value):
		var is_changed = (clampi(value, 0, 999) != _player_hp)
		_player_hp = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("player_hp")

var enemy_hp:
	get:
		return _enemy_hp
	set(value):
		var is_changed = (clampi(value, 0, 999) != _enemy_hp)
		_enemy_hp = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("enemy_hp")

var player_block:
	get:
		return _player_block
	set(value):
		var is_changed = (clampi(value, 0, 999) != _player_block)
		_player_block = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("player_block")
			print("change")

var enemy_block:
	get:
		return _enemy_block
	set(value):
		var is_changed = (clampi(value, 0, 999) != _enemy_block)
		_enemy_block = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("enemy_block")
			print("change")

func damage_player(damage):
	var effective_damage = damage * (1 + _enemy_str / 100.0) * (1 - _enemy_weak / 100.0)
	enemy_str = 0
	enemy_weak = 0
	if player_block > 0:
		if effective_damage > player_block:
			player_hp -= (effective_damage - player_block)
			player_block = 0
		else:
			player_block -= effective_damage
	else:
		player_hp -= effective_damage

func damage_enemy(damage):
	var effective_damage = damage * (1 + _player_str / 100.0) * (1 - _player_weak / 100.0)
	player_str = 0
	player_weak = 0
	if enemy_block > 0:
		if effective_damage > enemy_block:
			enemy_hp -= (effective_damage - enemy_block)
			enemy_block = 0
		else:
			enemy_block -= effective_damage
	else:
		enemy_hp -= effective_damage

func draw_cards() -> Array[OuterPart]:
	var rng = RandomNumberGenerator.new()
	var counts = amounts.duplicate()
	var drawn: Array[OuterPart] = []
	for i in range(hand_size):
		var choice = rng.rand_weighted(counts)
		var part = deck[choice]
		drawn.append(part.instantiate())
		counts[choice] -=1
	return drawn
