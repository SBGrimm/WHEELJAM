extends "res://scenes/map/encounters/encounter.gd"

@onready var base_sprite_scale = %CampfireSprite.scale

func _physics_process(delta: float) -> void:
	update_sprite_hover_scale(delta)
	%CampfireSprite.scale = hover_sprite_scale * base_sprite_scale

func encounter():
	print("Boring ass encounter")
