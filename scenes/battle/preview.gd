extends Control

@onready var player_hp = $HSplitContainer/PlayerPreview/HP
@onready var player_shield = $HSplitContainer/PlayerPreview/Block
@onready var player_strength = $HSplitContainer/PlayerPreview/Strength
@onready var player_weakness = $HSplitContainer/PlayerPreview/Weakness
@onready var enemy_hp = $HSplitContainer/EnemyPreview/HP
@onready var enemy_block = $HSplitContainer/EnemyPreview/Block
@onready var enemy_strength = $HSplitContainer/EnemyPreview/Strength
@onready var enemy_weakness = $HSplitContainer/EnemyPreview/Weakness

@onready var preview_dict = {
	"player_hp": player_hp,
	"player_block": player_shield,
	"player_strength": player_strength,
	"player_weakness": player_weakness,
	"enemy_hp": enemy_hp,
	"enemy_block": enemy_block,
	"enemy_strength": enemy_strength,
	"enemy_weakness": enemy_weakness,
}
