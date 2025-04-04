extends BaseScene
@onready var slot_1 = $Slot1
@onready var slot_2 = $Slot2
@onready var slot_3 = $Slot3
@onready var slots = [slot_1, slot_2, slot_3]
@onready var drop_zone = $DropZone
@onready var drop_nothing_button = $Button


func scene_theme(): 
	return preload("res://sounds/music/song-reward.mp3")

func _ready():
	reset()
	drop_nothing_button.pressed.connect(_on_drop_nothing_button_pressed)

func spawn(parts: Array[OuterPart]):
	for i in range(3):
		slots[i].set_part(parts[i])

func wipe():
	for slot in slots:
		slot.reset()
	if EventBus.ended_drag.is_connected(drop_zone._on_dropped):
		EventBus.ended_drag.disconnect(drop_zone._on_dropped)

func reset():
	wipe()
	spawn(GlobalGamestate.get_antirewards())
	EventBus.ended_drag.connect(drop_zone._on_dropped)

func _on_drop_zone_part_chosen(part: OuterPart):
	GlobalGamestate.amounts[part.id] -= 1
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
	wipe()

func _on_drop_nothing_button_pressed():
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
	wipe()
