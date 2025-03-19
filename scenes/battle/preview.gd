extends Control

@onready var player_hp = $HSplitContainer/PlayerPreview/HP
@onready var player_shield = $HSplitContainer/PlayerPreview/Block
@onready var player_strength = $HSplitContainer/PlayerPreview/Status
@onready var enemy_hp = $HSplitContainer/EnemyPreview/HP
@onready var enemy_block = $HSplitContainer/EnemyPreview/Block
@onready var enemy_strength = $HSplitContainer/EnemyPreview/Status

@onready var preview_dict = {
	"player_hp": player_hp,
	"player_block": player_shield,
	"player_status": player_strength,
	"enemy_hp": enemy_hp,
	"enemy_block": enemy_block,
	"enemy_status": enemy_strength,
}
