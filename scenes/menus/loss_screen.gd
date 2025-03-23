extends BaseScene

@onready var gradient = $Gradient
@onready var label = $Label


func scene_theme(): 
	return preload("res://sounds/music/song-intro.mp3")

func _ready():
	reset()

func reset():
	gradient.set("texture:fill_to", Vector2(0, 1))
	var tween = create_tween()
	tween.tween_property(gradient, "texture:fill_to", Vector2(0.15, 1), 2)
	randomize()
	var sucks = RandomNumberGenerator.new().randi_range(1, 4)
	if sucks == 1:
		label.text = """[center]You died[/center]
[center]sucks to suck[/center]"""
	else:
		label.text = """[center]You died[/center]"""


func _on_start_over_button_pressed():
	EventBus.request_scene_change_with_game_restart.emit(SceneManager.Scene.MAP)
	$ClickSFX.play()

func _on_back_to_menu_button_pressed():
	$ClickSFX.play()
	EventBus.request_scene_change_with_game_restart.emit(SceneManager.Scene.MAIN_MENU)

func _on_back_to_menu_button_mouse_entered() -> void:
	$HoverSFX.play()

func _on_start_over_button_mouse_entered() -> void:
	$HoverSFX.play()

func _on_start_over_button_mouse_exited() -> void:
	$HoverSFX.play()

func _on_back_to_menu_button_mouse_exited() -> void:
	$HoverSFX.play()
