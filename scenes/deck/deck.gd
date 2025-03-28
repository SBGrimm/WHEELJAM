extends BaseScene

const slot = preload("res://scenes/elements/slot.tscn")
@onready var grid_container = $GridContainer
@onready var exit_button = $Button

func _ready():
	exit_button.pressed.connect(_on_exit_button_pressed)

func reset():
	var deck = GlobalGamestate.get_deck()
	var new_slot: Slot
	for i in range(len(deck)):
		new_slot = slot.instantiate()
		grid_container.add_child(new_slot)
		var size = get_rect().size
		new_slot.set_part(deck[i])

func wipe():
	for child in grid_container.get_children():
		grid_container.remove_child(child)

func _on_exit_button_pressed():
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
	wipe()
