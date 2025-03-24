extends BaseScene

@onready var menu_items = $MenuItems
@onready var start_button = %StartButton
@onready var exit_button = %ExitButton
@onready var sfx_click = $ClickSFX
@onready var sfx_hover = $HoverSFX
@onready var gradient = $Gradient
@onready var animation_player = $AnimationPlayer

@export var no_hover = true

func scene_theme(): 
	return preload("res://sounds/music/song-intro.mp3")

func _ready():
	reset()

func reset():
	animation_player.play("start")

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


func _on_start_button_mouse_entered() -> void:
	if not no_hover:
		sfx_hover.play()


func _on_exit_button_mouse_entered() -> void:
	if not no_hover:
		sfx_hover.play()
