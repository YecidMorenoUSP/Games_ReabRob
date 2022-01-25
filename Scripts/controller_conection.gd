extends Node

var _IP = "127.0.0.1"
var _PORT = 2121

var connecting = false;

var input_values =  [ 0.0,    0.0 ,    0.0 ,    0.0    ]


var output_values = [ 0,   0,   0,   0    ]


var connection = StreamPeerTCP.new()


var TimerReconnect = Timer.new()

signal signal_connected()
signal signal_disconnected()

var thread
var mutex

var __CLOSE__ALL__ = false


func _ready():
	
		
	connection.set_no_delay( true )
	
	add_child(TimerReconnect)
	
	TimerReconnect.wait_time = 0.01;
	TimerReconnect.connect("timeout",self,"onTimerReconnect")
#	TimerReconnect.one_shot = true
#	TimerReconnect.autostart = true
#	TimerReconnect.start(0)
	
#	onTimerReconnect()
	
	connect("signal_disconnected",self,"on_Disconnect")
	
	set_process( false )
	
#	connection.disconnect_from_host()
#	connection.connect_to_host( _IP,_PORT )
	
	thread = Thread.new()
	mutex = Mutex.new()
	thread.start(self, "_thread_function")
	
#	Controller.connect_client("127.0.0.1",2121);
var __T0__ = 0
var __T1__ = 0
func _thread_function():
	while(true):
		Controller.mutex.lock()		
		if(Controller.__CLOSE__ALL__): 
			break;
		Controller.mutex.unlock()

		__T0__ = OS.get_ticks_msec()
		if connection.get_status() == connection.STATUS_CONNECTED: 
#			print("B2")
			Controller.mutex.lock()			
			send_data()
			
			receive_data()
		
			Controller.mutex.unlock()
			
		while((OS.get_ticks_msec() - __T0__) < (1.0/200.0)*1000):
			pass
	
	Controller.mutex.unlock()
	print("DONE")
		
	pass
	

var firstConnect = false
var firstDisconnect = false
func onTimerReconnect():
	if connection.get_status() != connection.STATUS_CONNECTED:
		
		if connection.get_status() != connection.STATUS_CONNECTED:
			connection.disconnect_from_host()
			connection.connect_to_host( _IP,_PORT )
			if(!firstDisconnect ):
				mutex.lock()
				print("Reiniciando: [IN: %d || OUT: %d]"%[input_values.size(),output_values.size()])
				mutex.unlock()
			firstDisconnect = true
			
				
			emit_signal("signal_disconnected")
			firstConnect = true;
			set_process( false )	
		return
		
	if firstConnect:
		TimerReconnect.stop()
		print("linpiando")

		for i in range(0,100000):
			connection.get_8()
			var a = connection.get_float()
			print(a)
			if a == len(Controller.input_values):
				connection.get_float()
				connection.get_float()
				print("Correcto")
				break
		print("linpiado")
		emit_signal("signal_connected")
		firstConnect = false;
		firstDisconnect = false
		set_process( true )
		TimerReconnect.start()	
		
var _input_values_ = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
var _input_values_n = 0;
func receive_data():
	
	mutex.lock()
	_input_values_n = input_values.size()
	mutex.unlock()
	
	if(connection.get_available_bytes() >= (_input_values_n+1)*3):
		connection.get_float()
		
		
		for idx in range( _input_values_n ):
			_input_values_[idx] = connection.get_float()
		
		mutex.lock()
		for idx in range( _input_values_n ):
			input_values[idx] = _input_values_[idx]
		mutex.unlock()
		
var output_buffer = StreamPeerBuffer.new()
func send_data():
	output_buffer.clear()
#	output_buffer.put_u16( output_status )
	output_buffer.put_float( len(output_values))
	mutex.lock()
	for value in output_values:
		output_buffer.put_float( value )
	mutex.unlock()
	if connection.get_status() == connection.STATUS_CONNECTED: 
		connection.put_data( output_buffer.data_array )
		return true
	
	return false
				

#func _process( delta ):
#	print(connection.is_connected_to_host())
	
	
	

func connect_client( host, port ):
	if not connection.is_connected_to_host():
		connection.connect_to_host( host, port )
		while connection.get_status() == connection.STATUS_CONNECTING: 
			print( "connecting to %s:%d" % [ host, port ] )
			pass
			continue
		if connection.is_connected_to_host(): 
#			for i in range(0,5):
#				connection.get_8();
			set_process( true )

func on_Disconnect():
	mutex.lock()
	for idx_vec in range(len(input_values)):
		input_values[idx_vec] = 0.0;
	for idx_vec in range(len(output_values)):
		output_values[idx_vec] = 0.0;
	mutex.unlock()
			
func _exit_tree():
	__CLOSE__ALL__ = false
	connection.disconnect_from_host()
	print("ME voy")
