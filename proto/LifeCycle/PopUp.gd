extends Control

func _ready():
	OS.center_window()
	# OS.shell_open("cmd")

	var rect = Rect2(Vector2(0, 0), OS.window_size)
	$Popup.popup(rect)
	
	update_label(clicks)

var clicks = 0

func update_label(clicks):
	$VBoxContainer/Label.text = "Clicks: " + str(clicks)

func _on_Button_pressed():
	clicks += 1
	update_label(clicks)
