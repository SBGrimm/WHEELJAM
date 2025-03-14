extends Control
class_name Slice

@export var mod: float
@onready var art = %art


func _ready():
	if mod == 0.5:
		art.texture = load("res://the-wheel-godot-main/Assets/wheel-simple/slice1.png")
	elif mod == 1:
		art.texture = load("res://the-wheel-godot-main/Assets/wheel-simple/slice2.png")
	elif mod == 2:
		art.texture = load("res://the-wheel-godot-main/Assets/wheel-simple/slice3.png")
	elif mod == 3:
		art.texture = load("res://the-wheel-godot-main/Assets/wheel-simple/slice4.png")
	
