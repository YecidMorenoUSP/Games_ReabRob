extends GridContainer

#onready var ControllerPlayer = $"/root/ControllerPlayer"

export(int) var Nplayer = 0;
onready var PlotP1Pos = get_node("LinePos")
onready var Kv = get_node("SpinBox")
onready var Bv = get_node("SpinBox2")

var timerPlot =  Timer.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timerPlot)
	timerPlot.set_wait_time(0.16)
	timerPlot.connect("timeout",self,"_timer_time_out")
	timerPlot.autostart = true;
	timerPlot.start(-1)
	
	Kv.connect("value_changed",self,"_KV_changed")
	Bv.connect("value_changed",self,"_BV_changed")
	
	
	pass # Replace with function body.

func _KV_changed(var value):	
	ControllerPlayer.Player[Nplayer]["Kv"] = value
	Kv.release_focus()
func _BV_changed(var value):	
	ControllerPlayer.Player[Nplayer]["Bv"] = value
	Bv.release_focus()
	
func _timer_time_out():
	PlotP1Pos.pushValue(ControllerPlayer.Player[Nplayer]["pos"]-300)
	Kv.value = ControllerPlayer.Player[Nplayer]["Kv"]
	Bv.value = ControllerPlayer.Player[Nplayer]["Bv"]
	


func _process(delta):
	
	
	pass
