extends Node2D

onready var Ball = $"Ball"

var GoalsSP = 5;

func _ready():
		
	Controller.mutex.lock()
	Controller.output_values = [0.0,0.0,0.0,0.0,0.0,0.0]
	Controller.input_values  = [0.0,0.0]
	Controller.mutex.unlock()
		
	
	
	Controller.connect("signal_connected",self,"on_Connected")
	Controller.connect("signal_disconnected",self,"on_disconnected")
	
	Ball.connect("body_entered",self,"_on_Ball_body_entered")
	Ball.connect("body_exited",self,"_on_Ball_body_exited")
	
	Controller.TimerReconnect.start(0)
	
#	on_disconnected()
#	reset()
	pass

func reset():
	Ball.FIRST_BALL = true
	$ControllerPlayer.Player[0]['score'] = 0
	$ControllerPlayer.Player[1]['score'] = 0
	$ControllerPlayer.Player[0]['Kv'] = $ControllerPlayer.Player[0]["KvK"]
	$ControllerPlayer.Player[0]['Bv'] = $ControllerPlayer.Player[0]["BvK"]
	$ControllerPlayer.Player[1]['Kv'] = $ControllerPlayer.Player[1]["KvK"]
	$ControllerPlayer.Player[1]['Bv'] = $ControllerPlayer.Player[1]["BvK"]
	updateScore()
	
	pass

func on_Connected():
	print("Connected Server")
	reset()
	pass

func on_disconnected():
		
	Ball.RESET_BALL = true
	pass	

func updateScore():
	$"Textos/Score1".text = "%d"%$ControllerPlayer.Player[0]['score']
	$"Textos/Score2".text = "%d"%$ControllerPlayer.Player[1]['score']

func _on_Ball_body_entered(body):
	Ball.get_node("AnimationPlayer").play("blur_1")
	body.modulate = Color(1.5,1.5,1.5,1)
	$poom.play()
	
	if(body == $Mesa/MetaP1 || body == $Mesa/MetaP2):
		var Nplayer = int(body.name[-1])-1
				
		if(Nplayer == 1):
			$ControllerPlayer.Player[1]['score'] += 1
			$ControllerPlayer.Player[1]['Kv'] += $ControllerPlayer.Player[1]["KvK"]
			$ControllerPlayer.Player[1]['Bv'] += $ControllerPlayer.Player[1]["BvK"]
		elif(Nplayer == 0):
			$ControllerPlayer.Player[0]['score'] += 1
			$ControllerPlayer.Player[0]['Kv'] += $ControllerPlayer.Player[0]["KvK"]
			$ControllerPlayer.Player[0]['Bv'] += $ControllerPlayer.Player[0]["BvK"]
		
	
		
		if ($ControllerPlayer.Player[1]['score'] == GoalsSP || 
			$ControllerPlayer.Player[0]['score'] == GoalsSP):
				
			$brasiiiil.play()
			Ball.RESET_BALL = true
			updateScore()
			$"Textos/Goal/AA".play("Finish")
		else:
			updateScore()
			$"Textos/Goal/AA".play("vortice")
			Ball.RESET_BALL = true		
	else:
		Ball.COLLIDE_BALL = true
	
	pass

func _on_Ball_body_exited(body):
	Ball.get_node("AnimationPlayer").play("blur_0")
	body.modulate = Color(1,1,1,1)
	pass

func _process(delta):
	if Input.is_action_pressed("resetBall"):
		Ball.PULSE_BALL = true
