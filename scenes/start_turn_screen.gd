extends ColorRect

var rng = RandomNumberGenerator.new()
@onready var pre_placed = $pre_placed
@onready var to_place = $to_place

func _ready():
	var packed: PackedScene = load("res://scenes/Outer Parts/player/damage_outer_part.tscn")
	var parts: Array[OuterPart] = [
		packed.instantiate(),
		packed.instantiate(),
		packed.instantiate(),
	]
	spawn(parts)

func spawn(parts: Array[OuterPart]):
	for part: OuterPart in parts:
		to_place.add_child(part)
		part.draggable = true
		part.global_position = pick_spot()
		part.rotation = rng.randi_range(0, 359)

func pick_spot():
	var x = rng.randf_range(137, 337)
	var y = rng.randf_range(140, 500)
	return Vector2(x, y)
