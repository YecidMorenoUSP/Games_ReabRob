extends RigidBody2D


onready var P0 = transform.origin

export(int) var  A_PI = 350


export(int) var idx = 0

func _ready():
#	P0 *= $"/root/Game".get_scale();
	pass # Replace with function body.

func _process(delta):
	var pos_d = Vector2(0, get_node("../ControllerPlayer").Player[idx]["pos"] )*A_PI
	var pos = transform.origin
	translate( (pos_d - pos + P0 ) )
#	transform.origin = P0 + pos_d

#	var pos_d2 = Vector2(0, get_node("../ControllerPlayer").Player[idx]["pos"] )*A_PI
#	transform.origin = P0 + pos_d2
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
