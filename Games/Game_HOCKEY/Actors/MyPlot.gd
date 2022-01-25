extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum {TYPE_1,TYPE_2}

export(PoolVector2Array) var Values = [];
export(int,"TYPE_1","TYPE_2") var Type = 0;

onready var line = get_node("Line2D");
onready var size = get_rect().size

var posYMax = 0
var posYMin = 0

func _ready():
	
	if not Values:
		Values = line.points;
	
	setNmostras(40);
	
	pass # Replace with function body.

func setNmostras(var N):
	while not (Values.empty()):
		Values.remove(0)
	
	for idx in range(0,N-1):
		Values.append(Vector2(size[0]/N * idx , 0))
	line.points = Values
	

func pushValue(var val):

	
	if( val > posYMax or val < posYMin):
		if(val > posYMax): posYMax = val
		elif(val < posYMin): posYMin = val
		
	if(Type == TYPE_1):
		for idx in range(0,len(Values)-1):
			Values[idx][1] = Values[idx+1][1]
		Values[len(Values)-1][1] = val
		
		
		for idx in range(0,len(Values)):
			line.points[idx][1] = Values[idx][1]/(1*(abs(posYMax)+abs(posYMin))) * size[1]
		
	
func _process(delta):
	
	pass
