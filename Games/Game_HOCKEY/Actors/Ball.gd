extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var RESET_BALL = false
export(bool) var RUN_BALL = false
export(bool) var FIRST_BALL = false
export(bool) var COLLIDE_BALL = false
export(bool) var PULSE_BALL = false


onready var P0 = transform.origin
var V0 = Vector2(-500,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	print($"/root/Game".get_scale())
	P0 *= $"/root/Game".get_scale();
	
	pass # Replace with function body.




var V_1 = V0
func _integrate_forces(state):
	if(FIRST_BALL):
		V_1 = -V0
		RUN_BALL = true
		FIRST_BALL = false
	
	if(RESET_BALL):
		state.transform.origin = P0
		V_1 = state.linear_velocity
		state.linear_velocity = V0 * Vector2(0,0) 
		RESET_BALL = false
	
	if(RUN_BALL):
		state.linear_velocity = V0 * Vector2(sign(V_1.x),1)
		RUN_BALL = false
		
	if(COLLIDE_BALL):
		state.linear_velocity = state.linear_velocity * 1.05;
		COLLIDE_BALL = false
		
	if(PULSE_BALL):
		state.linear_velocity = V0 * Vector2(-sign(state.linear_velocity.x),1);
		PULSE_BALL = false
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
