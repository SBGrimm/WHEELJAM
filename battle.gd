extends "res://scenes/map/encounters/encounter.gd"

@onready var base_sprite_scale = %BattleSprite.scale

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)
	%BattleSprite.scale = hover_sprite_scale * base_sprite_scale

func encounter():
	print("<PlayerName> was clubbed to death by a Zombie")
