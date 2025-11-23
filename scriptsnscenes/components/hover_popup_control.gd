extends Control

var pos : Vector2

func _draw() -> void:
	if pos:
		draw_circle(pos, 10, Color.RED)
