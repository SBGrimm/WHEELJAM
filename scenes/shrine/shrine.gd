extends BaseScene
@onready var slice_gimbal = %slice_gimbal

func reset():
	choose_gods()
	reset_wheel()
	
func choose_gods():
	pass

func reset_wheel():
	for i in range(6):
		slice_gimbal.get_children()[i].mod = GlobalGamestate.modifiers[i]

const steps = [0.2, 0.25, 0.33, 0.5, 1, 2, 3, 4, 5, 6, 7]

func upgrade_slice(i):
	var old_mod = GlobalGamestate.modifiers[i]
	GlobalGamestate.modifiers[i] = steps[steps.find(old_mod) + 1]

func degrade_slice(i):
	var old_mod = GlobalGamestate.modifiers[i]
	GlobalGamestate.modifiers[i] = steps[steps.find(old_mod) - 1]
