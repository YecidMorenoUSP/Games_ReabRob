extends Spatial

onready var ufo = get_node("Player/UFO")
onready var rayos = get_node("Player/Rayos")
onready var ref = get_node("Player/Reference")
onready var posPlayer = get_node("Player/PosPlayer")

onready var pos0UFO = ufo.transform.origin
onready var pos0MARKER = $Player/Marker.transform.origin

var maxAmgle = PI/10.0

var PI_A = 40
var velGraph = 5
var timer1 = Timer.new()
var timerplot = Timer.new()

var thread
var mutex

var points_  = [Vector3(0,0,0),Vector3(0,5,0)]

func _ready():
	
	
	
	thread = Thread.new()
	mutex = Mutex.new()
	thread.start(self, "_thread_function")
	
	Controller.mutex.lock()
	Controller.output_values = [0.0,0.0]
	Controller.input_values  = [0.0,0.0]
	Controller.mutex.unlock()
				
	set_process(false)
	Controller.connect("signal_connected",self,"on_Connected")
	Controller.connect("signal_disconnected",self,"on_Disconnect")
	
	Controller.TimerReconnect.start(0)
	pass

var __T0__ = 0
func _thread_function():
	var indexRef
	
	while(true):
		
		Controller.mutex.lock()		
		if(Controller.__CLOSE__ALL__): 
			Controller.mutex.unlock()		
			break;
		Controller.mutex.unlock()
		
		
		__T0__ = OS.get_ticks_msec()
		
		mutex.lock()
		indexRef = int((__T0__-time0_ms_)/(WaveCreator.Ts*1000.0))
		mutex.unlock()
#		print(indexRef)
		
		if((indexRef+4) > points_.size()):
			Controller.output_values[0] = 0
			
		else:
			Controller.mutex.lock()
			Controller.output_values[0] = points_[indexRef].y / PI_A
#			print(points_[indexRef].y / PI_A)
			Controller.mutex.unlock()
		
		Controller.mutex.lock()
		ufo.transform.origin.y = Controller.input_values[0]*PI_A*0.5 + pos0UFO.y# + Controller.input_values[0]*PI_A*2 + pos0UFO.y
#		print(Controller.input_values[0]*PI_A*0.5 + pos0UFO.y)
		Controller.mutex.unlock()
		
		while((OS.get_ticks_msec() - __T0__) < (1.0/200.0)*1000):
			
			pass
			
	print("Update closed")
	
	print("Se cerro el hilo de update");
	pass

func on_Disconnect():
	$AnimationPlayer.play("ping")
func on_Connected():
	$AnimationPlayer.play("RESET")
	print("Se conecto, corrale")
	
	$Player/UFO.transform.origin = pos0UFO
	$Player/Marker.transform.origin = pos0MARKER
	
	ref.transform.origin.x = get_node("Player/Marker").transform.origin.x #+ pos0UFO.x
	ref.transform.origin.y = get_node("Player/Marker").transform.origin.y #+ pos0UFO.y
	ref.transform.origin.z = get_node("Player/Marker").transform.origin.z #+ pos0UFO.z
	
	posPlayer.transform.origin.x = get_node("Player/Marker").transform.origin.x #- pos0UFO.x
	posPlayer.transform.origin.y = get_node("Player/Marker").transform.origin.y #- pos0UFO.y
	posPlayer.transform.origin.z = get_node("Player/Marker").transform.origin.z #- pos0UFO.z	
	
	reset()
	
	WaveCreator.clear()
	
	WaveCreator.constant(0,2)
	WaveCreator.sinosoidal(PI_A*maxAmgle*.8,1/8.0,0,8*1)
	WaveCreator.constant(0,4)
	WaveCreator.sinosoidal(PI_A*maxAmgle*.8,1/8.0,0,8*2)
	WaveCreator.constant(0,4)
	WaveCreator.sinosoidal(PI_A*maxAmgle*.8,1/8.0,0,8*1)
	WaveCreator.constant(0,2)

	points_ =  WaveCreator.get_data_fromPlot(velGraph)
	
	ref.points = WaveCreator.get_data_fromPlot_delta(velGraph,50)
	
	set_process(true)
	
	pass
	
func reset():
	time0_ms_ = OS.get_ticks_msec()
	indexRef = 0
	posIndex = 0
	score = 0
	posPlayer.points.clear()
	ref.points.clear()
	
	
func anim_RayoenUFO():
	var animufo = ufo.get_node("AnimationPlayer")
	var animrayo1 = rayos.get_node("Rayo1/AnimationPlayer")
	animufo.play("Shake")
	animrayo1.play("Rayo1")

var posNave = 0
var posRef = 0

var time0_ms_ = 0

var posIndex = 0
var indexRef = 0

var e2m = 0
var ref_d = 0
var FESstate = 0

var score = 0

func _process(delta):
	
	indexRef = posIndex/WaveCreator.Ts
	
	if((indexRef+5) > points_.size()):
		
		reset()
		
		return
	
	posRef = points_[indexRef].y / PI_A
	
#	Controller.mutex.lock()
#	ufo.transform.origin.y = Controller.input_values[0]*PI_A*0.5 + pos0UFO.y# + Controller.input_values[0]*PI_A*2 + pos0UFO.y
#	Controller.mutex.unlock()
	posNave = ufo.transform.origin.y - pos0UFO.y

	
	e2m = pow(posNave-posRef,2)/2.0
	
	if(e2m<4):
		score += (1.0/(abs(e2m)+1.0))
	
	ref_d  = ( - points_[indexRef].y + points_[indexRef+5].y ) / delta
	
	if( ref_d  > 0 && posRef>0):
		FESstate = 1
		anim_RayoenUFO()
	else:
		FESstate = 0
	
#	Controller.output_values[0] = posRef
#	Controller.output_values[1] = FESstate
	
	get_node("Player/Marker").transform.origin.y = ufo.transform.origin.y + (pos0MARKER.y - pos0UFO.y)
	posPlayer.points.append(Vector3(posIndex*velGraph, posNave*2,ref.transform.origin.z))
	
	ref.transform.origin.x -= velGraph*delta/2.0
	posPlayer.transform.origin.x -= velGraph*delta/2.0
	
	$Label.text = "Time : %f \nIndex : %d\n"%[posIndex,indexRef]
	$Label.text += "posNave : %f\n"%[posNave]
	$Label.text += "posRef  : %f\n"%[posRef]
	$Label.text += "e2m  : %f\n"%[e2m]
	$Label.text += "FES  : %d\n"%[FESstate]
	
	$Score.text = "Score: %d"%[score]
	
	posIndex += delta
	pass
	
func _exit_tree():
#	thread.wait_to_finish()	
	pass
