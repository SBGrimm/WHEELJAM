extends "res://scenes/map/encounters/encounter.gd"

@onready var base_sprite_scale = %DarkShrineSprite.scale

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)
	%DarkShrineSprite.scale = hover_sprite_scale * base_sprite_scale

func encounter():
	print("THE GOD DOES NOT LOVE YOU. NOR DOES IT WANT YOUR WORSHIP. YOU ARE NOT BUT A MERE PLAYTHING TO IT.")
