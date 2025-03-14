extends Resource
class_name GameState

@export var _player_hp = 0
@export var _enemy_hp = 0
@export var _player_block = 0
@export var _enemy_block = 0
signal gamestate_changed


var player_hp:
	get:
		return _player_hp
	set(value):
		var changed = (clampi(value, 0, 999) != _player_hp)
		_player_hp = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
var enemy_hp:
	get:
		return _enemy_hp
	set(value):
		var changed = (clampi(value, 0, 999) != _enemy_hp)
		_enemy_hp = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()

var player_block:
	get:
		return _player_block
	set(value):
		var changed = (clampi(value, 0, 999) != _player_block)
		_player_block = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()

var enemy_block:
	get:
		return _enemy_block
	set(value):
		var changed = (clampi(value, 0, 999) != _enemy_block)
		_enemy_block = clampi(value, 0, 999)
		if changed:
			gamestate_changed.emit()
