extends Control
class_name OuterPart

@onready var effects_list = $EffectsList
@onready var draggable = $DraggableComponent.draggable

func get_effects() -> Array[Effect]:
	var effects: Array[Effect] = []
	for effect: Effect in effects_list.get_children():
		effects.append(effect)
	return effects
