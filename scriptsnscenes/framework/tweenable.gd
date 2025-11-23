extends Node
class_name Tweenable
## Makes parent tweenable

@export var offset : Vector3
@export var duration : float = 1.5
@export var use_global : bool = true

var par : Node3D
var og : Vector3

func _ready() -> void:
	par = get_parent()
	if not par: 
		push_error("Invalid parent of tweenable")
		queue_free()
	par.add_to_group("tweenable")
	og = par.global_position if use_global else par.position

func tween(backwards:bool=false):
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	var property := "global_position" if use_global else "position"
	if not backwards:
		t.tween_property(par, property, og+offset, duration)
	else:
		t.tween_property(par, property, og, duration)
