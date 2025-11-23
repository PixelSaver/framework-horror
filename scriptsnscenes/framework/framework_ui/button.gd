extends Button

func _on_mouse_entered():
	scale = Vector2.ONE * 2



func _on_mouse_exited() -> void:
	scale = Vector2.ONE
