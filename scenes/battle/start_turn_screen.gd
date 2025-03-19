extends ColorRect

var rng = RandomNumberGenerator.new()
@onready var to_place = $to_place
@onready var spawn_zone = $SpawnZone
@onready var pre_places: Array[Control] = [$Place1, $Place3, $Place5]
@onready var places: Array[OuterPartPlace] = [$Place2, $Place4, $Place6]

signal parts_chosen(parts: Array[OuterPart])

func _ready():
	$Place2.part_slotted.connect(check_parts_chosen)
	$Place4.part_slotted.connect(check_parts_chosen)
	$Place6.part_slotted.connect(check_parts_chosen)
	
func reset(player_parts, enemy_parts):
	for place in places:
		place.reset()
	for place in pre_places:
		for child in place.get_children():
			place.remove_child(child)
	for child in to_place.get_children():
		to_place.remove_child(child)
	spawn(player_parts)
	pre_place(enemy_parts)

func activate():
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func deactivate():
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

func check_parts_chosen():
	for place in places:
		if not place.state == place.STATE.OCCUPIED:
			return
	setup_turn()

func pre_place(parts: Array[OuterPart]):
	for i in range(parts.size()):
		pre_places[i].add_child(parts[i])
		
func spawn(parts: Array[OuterPart]):
	for part: OuterPart in parts:
		to_place.add_child(part)
		part.z_index = 2
		part.draggable_component.draggable = true
		part.global_position = pick_spot()
		#part.rotation_degrees = rng.randi_range(0, 359)

func pick_spot():
	var rect = $SpawnZone.get_global_rect()
	var x = rng.randf_range(rect.position.x, rect.end.x)
	var y = rng.randf_range(rect.position.y, rect.end.y)
	return Vector2(x, y)

func setup_turn():
	var parts: Array[OuterPart] = [
		pre_places[0].get_child(0) as OuterPart,
		places[0].get_child(1) as OuterPart,
		pre_places[1].get_child(0) as OuterPart,
		places[1].get_child(1) as OuterPart,
		pre_places[2].get_child(0) as OuterPart,
		places[2].get_child(1) as OuterPart
	]
	parts_chosen.emit(parts)
	deactivate()
