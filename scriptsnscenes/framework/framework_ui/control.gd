extends Control

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print("mouse local pos: %s" % event.position)
