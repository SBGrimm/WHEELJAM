extends Control

#region Signals
signal new_dir_hovered() ## emitted when a new direction is hovered
signal new_dir_chosen(selection:Slice) ## emitted when a direction is chosen
signal rotation_started ## emitted when the gimbal begins to be rotated.
signal rotation_finished ## emitted when the gimbal is finished rotating.
signal puzzle_finished ## emitted when the puzzle is complete.
#endregion

#region Export Variables
@export var anim_time: float
#endregion

#region Onready Variables
@onready var selector:Control = %selector ## a reference to our selector node.
@onready var slice_gimbal:Control = %slice_gimbal ## a reference to our slice gimbal.
@onready var outer_gimbal:Control = %outer_gimbal ## a reference to our outer gimbal.
#endregion

#region Internal Variables
var current_value_mappings:Array[int] = [0,60,120,180,240,300]
enum WheelState {AWAITING_SELECTION,ROTATING,NO_INPUT} ## enum dictating current state of wheel.
var _state:WheelState = WheelState.NO_INPUT ## variable containing current state of wheel.
var num_selections:int = 0 ## how many selections have been chosen
var current_direction:int = 0 ## where the selector currently is.
var target_selections:int = 6 ## how many selections are allowed; default is 4.
#endregion

#region Built-In Functions
#called when the scene is loaded into the tree
func _ready()->void:
	reset() # all the setup is contained in reset
	rotation_finished.connect(end_check) # check if puzzle is completed when rotation is done
# handles input for our minigame
func _unhandled_input(event: InputEvent) -> void:
	if _state != WheelState.AWAITING_SELECTION: return
	if event is InputEventMouseButton:
		process_confirm_input(current_direction)
	elif event is InputEventMouseMotion:
		current_direction = rad_to_deg(self.global_position.angle_to_point(event.position))+120
		if current_direction < 0:
			current_direction +=360
		current_direction = round(current_direction/60)*60
		process_direction_input(current_direction)
#endregion

#region Custom Functions
func activate():
	_state = WheelState.AWAITING_SELECTION


func deactivate():
	_state = WheelState.NO_INPUT


## processes the hover direction and moves the selector to that direction.
func process_direction_input(direction:int)->void:
	if _state != WheelState.AWAITING_SELECTION: return
	selector.rotation_degrees = direction #move our selector to the direction
	new_dir_hovered.emit() # emit signal that we have moved the selector
	EventBus.update_battle_preview.emit()

## processes the current selection being clicked
func process_confirm_input(direction:int)->void:
	if _state != WheelState.AWAITING_SELECTION: return
	for x:Control in %covers.get_children():  # show the covers, increase the num selections, emit the signal, rotate
		if int(round(x.rotation_degrees)) == direction: 
			if x.visible: return 
			x.visible = true
			num_selections += 1
			new_dir_chosen.emit(get_current_wheel_selection())
			rotate_slices()

## rotates the slice gimbal +60 degrees
func rotate_slices(angle: int = 60)->void:
	#if _state != WheelState.AWAITING_SELECTION: return
	_state = WheelState.ROTATING 
	current_value_mappings = _rotate_array(current_value_mappings, angle) # +90 to each of our current value mappings
	rotation_started.emit() 
	var tween:Tween = create_tween() # create our tween object we will use for the animation
	tween.set_trans(8) # sets our transition type to our enum
	tween.tween_property(%slice_gimbal, "rotation_degrees",%slice_gimbal.rotation_degrees+angle,anim_time * angle/60) # rotate gimbal
	tween.finished.connect(func(): rotation_finished.emit()) # emit rotation finished when done anim

## this function resets the minigame.
func reset()->void:
	selector.rotation_degrees = 0 # remove this if you don't want the selector to reset up every time
	slice_gimbal.rotation_degrees = 0 
	num_selections = 0 
	for x:Control in %covers.get_children(): 
		x.visible = false # hides the covers
	var i = 0
	for outer: Control in %outer_gimbal.get_children(): 
		outer.rotation_degrees = 60*i
		i+=1
	i = 0
	for slice: Control in %slice_gimbal.get_children(): 
		slice.rotation_degrees = 60*i
		i+=1

## checks if the minigame is finished
func end_check()->void:
	if num_selections == target_selections:
		_state = WheelState.NO_INPUT
		puzzle_finished.emit()
	else:
		_state = WheelState.AWAITING_SELECTION

func spin():
	var rng = RandomNumberGenerator.new()
	rotate_slices(60*rng.randi_range(1, 5))

func set_outer_parts(parts: Array[OuterPart]):
	for child in outer_gimbal.get_children():
		outer_gimbal.remove_child(child)
	for part in parts:
		var new_part = part.duplicate(7)
		outer_gimbal.add_child(new_part)
		new_part.z_as_relative = true
		new_part.z_index = 0
		new_part.set_offsets_preset(Control.PRESET_CENTER)
		
func get_current_wheel_selection()->WheelSelection:
	var ws = WheelSelection.new()
	for x:int in current_value_mappings.size():
		if current_direction == current_value_mappings[x]:
			var slice = slice_gimbal.get_children()[x] as Slice
			ws.mod = slice.mod
	ws.effects = outer_gimbal.get_children()[current_direction/60].get_effects()
	return ws
#endregion

#region helper functions
func _rotate_array(arr:Array, angle: int = 60)->Array:
	for x:int in arr.size():
		arr[x] += angle
		if int(arr[x]) >= 360: arr[x] -= 360
	return arr
#endregion
