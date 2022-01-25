extends Node

var Ts = 1/200.0
var Tcur = 0
var T0 = 0
var values = []

func _ready():
	set_process(false)
	
func timeVec(val):
	T0 = Tcur
	Tcur += val
	return range((Tcur-val)/Ts,((Tcur)/Ts))
	
func clear():
	T0 = 0
	Tcur = 0
	values = []
	
func constant(val,time):	
	for i in timeVec(time):
		values.append(Vector2(i*Ts,val))
	
func sinosoidal(A,f,phi,time):
	for i in timeVec(time):
		values.append(Vector2(i*Ts,A*sin(2*PI*f*(i*Ts - T0)+phi)))
		
		
func printValues():
	for val in values:
		print(val)

func get_vector2():
	return values

func get_vector3():
	var values3 = []
	for val in values:
		values3.append(Utils.vec2ToVec3(val))
	return values3

func get_data_fromPlot(vel):
	var data = []
	for val in values:
		data.append(Utils.vec2ToVec3(val)*Vector3(vel,1,1))
	return data

func get_data_fromPlot_delta(vel,di):
	var data = []
	var idx = 0
	for val in values:
		if(idx%di == 0):
			data.append(Utils.vec2ToVec3(val)*Vector3(vel,1,1))
		idx += 1
	return data
