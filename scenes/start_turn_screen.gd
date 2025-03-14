extends ColorRect

var rng = RandomNumberGenerator.new()
@onready var pre_placed = $pre_placed
@onready var to_place = $to_place
@onready var place_6 = $Place6
@onready var place_4 = $Place4
@onready var place_2 = $Place2

signal parts_chosen(parts: Array[OuterPart])

func _ready():
	var packed: PackedScene = load("res://scenes/Outer Parts/player/damage_outer_part.tscn")
	var parts: Array[OuterPart] = [
		packed.instantiate(),
		packed.instantiate(),
		packed.instantiate(),
	]
	spawn(parts)
	place_2.part_slotted.connect(check_parts_chosen)
	place_4.part_slotted.connect(check_parts_chosen)
	place_6.part_slotted.connect(check_parts_chosen)

func activate():
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	

func check_parts_chosen():
	for node in [place_2, place_4, place_6]:
		if not node.state == node.STATE.OCCUPIED:
			return
	setup_turn()

func spawn(parts: Array[OuterPart]):
	for part: OuterPart in parts:
		to_place.add_child(part)
		part.draggable_component.draggable = true
		part.global_position = pick_spot()
		part.rotation_degrees = rng.randi_range(0, 359)

func pick_spot():
	var x = rng.randf_range(137, 337)
	var y = rng.randf_range(140, 500)
	return Vector2(x, y)
	
func setup_turn():
	var preplaced = pre_placed.get_children()
	var parts: Array[OuterPart] = [
		preplaced[0] as OuterPart,
		place_2.get_child(1) as OuterPart,
		preplaced[1] as OuterPart,
		place_4.get_child(1) as OuterPart,
		preplaced[2] as OuterPart,
		place_6.get_child(1) as OuterPart
	]
	parts_chosen.emit(parts)
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	#tween.finished.connect(passe)
