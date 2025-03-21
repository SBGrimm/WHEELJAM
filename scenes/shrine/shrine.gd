extends BaseScene

@onready var wheel = $Wheel
@onready var option_1 = $"Option 1"
@onready var option_2 = $"Option 2"

func _ready():
	wheel.new_dir_chosen.connect(_on_slice_chosen)
	option_1.option_chosen.connect(_on_option_1_chosen)
	option_2.option_chosen.connect(_on_option_2_chosen)
	reset()

var parts: Array[OuterPart] = [
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
	preload("res://scenes/Outer Parts/!outer_part_base.tscn").instantiate(),
]

var slice_index = -1

func reset():
	slice_index = -1
	wheel.set_outer_parts(parts)
	wheel.reset()
	wheel.activate()
	option_1.hide()
	option_2.hide()

const steps = [0.2, 0.25, 0.33, 0.5, 1, 2, 3, 4, 5, 6, 7]

func _on_slice_chosen(wheel_selection: WheelSelection):
	wheel.deactivate()
	slice_index = wheel_selection.slice_index
	option_1.show()
	option_2.show()

func _on_option_1_chosen():
	if slice_index == -1:
		return
	upgrade_slice(slice_index)
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)

func _on_option_2_chosen():
	if slice_index == -1:
		return
	degrade_slice(slice_index)
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)

func upgrade_slice(i):
	var old_mod = GlobalGamestate.modifiers[i]
	GlobalGamestate.modifiers[i] = steps[steps.find(old_mod) + 1]

func degrade_slice(i):
	var old_mod = GlobalGamestate.modifiers[i]
	GlobalGamestate.modifiers[i] = steps[steps.find(old_mod) - 1]
