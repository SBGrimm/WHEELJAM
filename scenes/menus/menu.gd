extends BaseScene

@onready var menu_items = $MenuItems
@onready var start_button = %StartButton
@onready var exit_button = %ExitButton
@onready var sfx_click = $ClickSFX
@onready var gradient = $Gradient

func _ready():
	reset()

func reset():
	var tween = create_tween()
	var tween2 = create_tween()
	exit_button.disabled = true
	start_button.disabled = true
	menu_items.modulate = Color(255, 255, 255, 0)
	gradient.set("texture:fill_to", Vector2(0.5, -0.3))
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(gradient, "texture:fill_to", Vector2(0, 1), 2)
	tween.tween_property(menu_items, "modulate:a", 1, 4)
	tween.tween_callback(func(): exit_button.disabled = false;start_button.disabled = false)
	tween2.tween_callback(bounce_light_forward)

func bounce_light_forward():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	var time = RandomNumberGenerator.new().randf_range(0.4, 0.8)
	tween.tween_property(gradient, "texture:fill_to", Vector2(0, 0.93), time)
	tween.tween_callback(bounce_light_backward)

func bounce_light_backward():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	var time = RandomNumberGenerator.new().randf_range(0.4, 0.8)
	tween.tween_property(gradient, "texture:fill_to", Vector2(0, 1), time)
	tween.tween_callback(bounce_light_forward)

func _on_exit_button_pressed():
	sfx_click.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()

func _on_start_button_pressed():
	sfx_click.play()
	EventBus.request_scene_change.emit(SceneManager.Scene.MAP)
