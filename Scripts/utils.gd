extends Node

var Debuging = true

func Debug(txt):
	if(Debuging):
		print(txt)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


func vec3ToVec2(vec3, axis):
	var array = [vec3.x, vec3.y, vec3.z]
	array.remove(axis)
	return Vector2(array[0], array[1])

func vec2ToVec3(vec2, axis=2, value=0):
	var array = [vec2.x, vec2.y]
	array.insert(axis, value)
	return Vector3(array[0], array[1], array[2])
