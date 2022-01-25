extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var adminGUI = get_node("../AdminGUI")
var showing = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	
		
		
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ShowAdmin_pressed():
	showing = !showing;
	if showing:
		OS.set_window_size(Vector2(1024,800))
		adminGUI.visible = true;
	else:
		OS.set_window_size(Vector2(1024,600))
		adminGUI.visible = false;
	pass # Replace with function body.
