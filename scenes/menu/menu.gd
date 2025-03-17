extends Control

@onready var start_button = $StartButton
@onready var exit_button = $ExitButton

var next_scene = preload("res://scenes/battle.tscn")

func _on_exit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(next_scene)
