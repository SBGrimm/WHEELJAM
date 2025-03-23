extends Resource
class_name WheelSelection

var mod: float
var part: OuterPart

var effects:
	get: 
		return part.get_effects()

var slice_index: int
