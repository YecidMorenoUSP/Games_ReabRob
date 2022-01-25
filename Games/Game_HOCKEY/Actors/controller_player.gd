extends Node

enum {TYPE_PLAYER,TYPE_IA,TYPE_ANKLEBOT,TYPE_SPAR}

var PlayerCC = {
	"type" : TYPE_IA,
	"name":"Player",
	"score" : 0,
	"pos" : 0,
	"Kv" : 10.0,
	"Bv" : 1.0,
	"FES" : 0,
	"KvK" : 10.0,
	"BvK" : 3.0,
}

var Player = [PlayerCC.duplicate() ,  PlayerCC.duplicate()];

func _ready():
	
	Player[0]["KvK"]  = 4;
	Player[0]["BvK"] = .4;
	
	Player[1]["KvK"]  = 10;
	Player[1]["BvK"]  = 2;

	
	Controller.output_values = [0.0,0.0,0.0,0.0,0.0,0.0]
	Controller.input_values  = [0.0,0.0]

	pass # Replace with function body.
	
func _process(delta):
	Controller.mutex.lock()
#	print(Controller.input_values)
#	$Label.text =  var2str(Controller.input_values)
	Player[1]["pos"] = -Controller.input_values[0]
	Player[0]["pos"] = -Controller.input_values[1]
	
	Controller.output_values[0] = Player[0]["Kv"];
	Controller.output_values[1] = Player[0]["Bv"];
	Controller.output_values[2] = Player[0]["FES"];
	Controller.output_values[3] = Player[1]["Kv"];
	Controller.output_values[4] = Player[1]["Bv"];
	Controller.output_values[5] = Player[1]["FES"];
	Controller.mutex.unlock()
	pass # Replace with function body.
