extends Control
class_name OuterPart

@onready var effects_list = $EffectsList
@onready var draggable_component = $art
@onready var animation_player = $AnimationPlayer
@onready var label = $Panel/Label

@export var text: String
@export var hoverable: bool
@export var id: int

func get_formatted_text(mod: float = 1):
	var values = []
	for effect in effects_list.get_children():
		values.append(roundi(effect.amount * mod))
	return text.format(values)

func get_effects() -> Array[Effect]:
	var effects: Array[Effect]
	for effect: Effect in effects_list.get_children():
		effects.append(effect)
	return effects

func _ready():
	label.text = get_formatted_text()

func expand():
	animation_player.play("expand")

func contract():
	animation_player.play("contract")
