extends Resource
class_name BattleState

var enemy: Enemy

@export var _player_hp = 0
@export var _enemy_hp = 0
@export var _player_block = 0
@export var _enemy_block = 0
@export var _enemy_status = 0
@export var _player_status = 0

@export var hand_size = 5
@export var parts = [
	preload("res://scenes/Outer Parts/player/damage_outer_part.tscn")
]
@export var amounts: PackedFloat32Array

signal gamestate_changed(property: String)

var enemy_status:
	get:
		return _enemy_status
	set(value):
		var is_changed = (clampi(value, -100, 999) != _enemy_status)
		_enemy_status = clampi(value, -100, 999)
		if is_changed:
			gamestate_changed.emit("enemy_status")

var player_status:
	get:
		return _player_status
	set(value):
		var is_changed = (clampi(value, -100, 999) != _player_status)
		_player_status = clampi(value, -100, 999)
		if is_changed:
			gamestate_changed.emit("player_status")

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

var enemy_block:
	get:
		return _enemy_block
	set(value):
		var is_changed = (clampi(value, 0, 999) != _enemy_block)
		_enemy_block = clampi(value, 0, 999)
		if is_changed:
			gamestate_changed.emit("enemy_block")

func damage_player(damage):
	var effective_damage = damage * (1 + enemy_status / 100.0)
	enemy_status = 0
	if player_block > 0:
		if effective_damage > player_block:
			player_hp -= (effective_damage - player_block)
			player_block = 0
		else:
			player_block -= effective_damage
	else:
		player_hp -= effective_damage

func damage_enemy(damage):
	var effective_damage = damage * (1 + player_status / 100.0)
	player_status = 0
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
		var part = parts[choice]
		drawn.append(part.instantiate())
		counts[choice] -=1
	return drawn
