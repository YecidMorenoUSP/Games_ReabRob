extends Spatial

export(bool) var anim1

signal animate(name,state)

enum {_ROTATE_1}

var Animations = {
	_ROTATE_1:[false, funcref(self,"f_ROTATE_1")]
}

var vel_rotation = .1

func _ready():
	
	connect("animate",self,"on_animate")
	
	emit_signal("animate",_ROTATE_1,true)
	
	


func _process(delta):
	for idx in Animations:
		var anim = Animations[idx]
		if(anim[0]):
			anim[1].call_func(delta)

	
func f_ROTATE_1(delta):
	rotation += Vector3(0,1,0)*vel_rotation*delta
	
func on_animate(name,state):
	Animations[name][0] = state
