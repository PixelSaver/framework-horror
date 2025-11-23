class_name HoverComponent
extends Node
## Class to animate parent control node

@export var duration : float = 0.3
var par : Control

func _ready() -> void:
	par = get_parent()
	if !par: queue_free()
	par.mouse_entered.connect(_on_hover)
	par.mouse_exited.connect(_on_unhover)
	if par is Button:
		par.pressed.connect(_on_pressed)
func _on_hover() -> void:
	par.pivot_offset = par.size/2.
	var t : Tween = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(par, "modulate", Color.LIGHT_PINK, duration)
	t.tween_property(par, "scale", Vector2.ONE * 1.1, duration)
func _on_unhover() -> void:
	var t : Tween = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(par, "modulate", Color.WHITE, duration)
	t.tween_property(par, "scale", Vector2.ONE, duration)
func _on_pressed() -> void:
	var t : Tween = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK).set_parallel(true)
	t.tween_property(par, "scale", Vector2.ONE, duration/3.)
	t.chain()
	t.tween_property(par, "scale", Vector2.ONE * 1.1, duration/2.)
	
