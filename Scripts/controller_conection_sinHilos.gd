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


func _ready():
	
	thread = Thread.new()
	thread.start(self, "_thread_function")
	
	connection.set_no_delay( true )
	
	add_child(TimerReconnect)
	
	TimerReconnect.wait_time = 0.01;
	TimerReconnect.connect("timeout",self,"onTimerReconnect")
#	TimerReconnect.one_shot = true
#	TimerReconnect.autostart = true
	TimerReconnect.start(0)
	
#	onTimerReconnect()
	
	connect("signal_disconnected",self,"on_Disconnect")
	
	set_process( false )
#	Controller.connect_client("127.0.0.1",2121);

func _thread_function():
	print("Hola")
	pass
	

var firstConnect = false
func onTimerReconnect():
	if connection.get_status() != connection.STATUS_CONNECTED:
		
		connection.disconnect_from_host()
		
		
		connection.connect_to_host( _IP,_PORT )
		if connection.get_status() != connection.STATUS_CONNECTED:
			print("Reiniciando: [IN: %d || OUT: %d]"
				%[input_values.size(),output_values.size()])
				
			emit_signal("signal_disconnected")
			firstConnect = true;
			set_process( false )	
		return
		
	if firstConnect:
		TimerReconnect.stop()
		print("linpiando")
		for i in range(0,5):
			connection.get_8();
		print("linpiado")
		emit_signal("signal_connected")
		firstConnect = false;
		set_process( true )
		TimerReconnect.start()	
		
	
func receive_data():
	
	if(connection.get_available_bytes() >= (len(input_values)+1)*3):
		connection.get_float()
		for idx in range( input_values.size() ):
			input_values[idx] = connection.get_float()
		
var output_buffer = StreamPeerBuffer.new()
func send_data():
	output_buffer.clear()
#	output_buffer.put_u16( output_status )
	output_buffer.put_float( len(output_values))
	for value in output_values:
		output_buffer.put_float( value )
		
	if connection.get_status() == connection.STATUS_CONNECTED: 
		connection.put_data( output_buffer.data_array )
		return true
	
	return false
				

func _process( delta ):
#	print(connection.is_connected_to_host())
	if connection.get_status() == connection.STATUS_CONNECTED: 
		send_data()
		receive_data()
#		updatePlayer()
	else:
		print("Pausado")
		set_process( false )
		pass
	
	

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
	for idx_vec in range(len(input_values)):
		input_values[idx_vec] = 0.0;
	for idx_vec in range(len(output_values)):
		output_values[idx_vec] = 0.0;
			
